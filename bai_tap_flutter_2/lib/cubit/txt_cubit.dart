import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logging/logging.dart';
import 'package:untitled1/model/txt.dart';

part 'txt_state.dart';

class TxtCubit extends Cubit<TxtState> {
  TxtCubit() : super(const TxtState());

  List<Txt> listTxt = [];
  final Logger logger = Logger('');

  void nhapGhiChu(String a) {
    String imageName = DateTime.now().toString().split('.')[0];
    Txt i = Txt(key: imageName, name: a.toString());
    DatabaseReference postListRef = FirebaseDatabase.instance.ref();
    postListRef.child('Txt').push().set(i.toJson());
    listTxt.add(i);
    emit(state.copyWith(txts: listTxt, status: TxtStatus.success));
  }

  void xoaGhiChu(int index) {
    DatabaseReference delete =
        FirebaseDatabase.instance.ref().child('Txt/${listTxt[index].key}');
    delete.remove();
    listTxt.removeAt(index);
    emit(state.copyWith(txts: listTxt, status: TxtStatus.start));
  }

  void hienThiGhiChu() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Txt').orderByChild('name');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        listTxt.clear();
        values.forEach((key, item) {
          listTxt.add(Txt(key: key, name: item['name'].toString()));
        });
        emit(state.copyWith(txts: listTxt, status: TxtStatus.success));
      }, onError: (error) {});
    } catch (e) {
      logger.warning('Lỗi : $e');
    }
  }
}
