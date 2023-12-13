import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
import 'package:untitled1/model/img.dart';

part 'img_state.dart';

class ImgCubit extends Cubit<ImgState> {
  ImgCubit() : super(const ImgState());
  List<Img> listAnh = [];

  final Logger logger = Logger('');

  void luuAnh(Uint8List? imageBytes) async {
    try {
      emit(state.copyWith(status: ImgStatus.start));
      if (imageBytes != null) {
        String imageName = DateTime.now().toString().split('.')[0];

        final firebaseStorage =
            FirebaseStorage.instance.ref().child('$imageName.PNG');
        firebaseStorage.putData(imageBytes);

        Reference ref = FirebaseStorage.instance.ref();
        String url = await ref.child('$imageName.PNG').getDownloadURL();
        Img i = Img(key: '', name: '$imageName.PNG', link: url);
        listAnh.add(i);

        DatabaseReference postListRef = FirebaseDatabase.instance.ref();
        postListRef.child('Img').push().set(i.toJson());

        emit(state.copyWith(imgs: listAnh, status: ImgStatus.success));
      }
    } catch (e) {
      logger.warning('Lỗi : $e');
    }
  }

  Future<void> hienThiAnh() async {
    try {
      emit(state.copyWith(status: ImgStatus.start));
      Query refAnh = FirebaseDatabase.instance.ref('Img').orderByChild('name');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        listAnh.clear();
        values.forEach((key, item) async {
          listAnh.add(Img(
              key: key,
              name: item['name'].toString(),
              link: item['link'].toString()));
        });
        Future.delayed(const Duration(seconds: 1), () {
          emit(state.copyWith(imgs: listAnh, status: ImgStatus.success));
        });
      });
    } catch (e) {
      logger.warning('Lỗi : $e');
    }
  }

  void xoaAnh(int index) async {
    emit(state.copyWith(status: ImgStatus.start));
    DatabaseReference deleteFB =
        FirebaseDatabase.instance.ref().child('Img/${listAnh[index].key}');
    deleteFB.remove();
    final desertRef =
        FirebaseStorage.instance.ref().child(listAnh[index].name.toString());
    await desertRef.delete();
    listAnh.removeAt(index);
    emit(state.copyWith(imgs: listAnh, status: ImgStatus.success));
  }
}
