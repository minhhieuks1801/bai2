import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:untitled1/cubit/img_state.dart';
import 'package:untitled1/model/img.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class ImgCubit extends Cubit<ImgState> {
  ImgCubit() : super(const ImgState());

  List<Img> listAnh = [];
  final Logger logger = Logger('');

  void hienThiAnh() {
    try {
      listAnh.clear();
      emit(state.copyWith(status: ImgStatus.start));
      Reference ref = FirebaseStorage.instance.ref();
      Query refAnh = FirebaseDatabase.instance.ref('Img').orderByChild('name');
      refAnh.onValue.listen((event) async {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;

        values.forEach((key, item) async {
          String url =
              await ref.child(item['name'].toString()).getDownloadURL();
          listAnh.add(Img(key: key, name: item['name'].toString(), link: url));
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
    DatabaseReference deleteFB =
        FirebaseDatabase.instance.ref().child('Img/${listAnh[index].key}');
    deleteFB.remove();
    final desertRef =
        FirebaseStorage.instance.ref().child(listAnh[index].name.toString());
    await desertRef.delete();
    hienThiAnh();
  }
}
