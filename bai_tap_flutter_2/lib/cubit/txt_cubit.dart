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
    emit(state.copyWith(status: TxtStatus.start));
    Txt i = Txt(key: '', name: a.toString());
    DatabaseReference postListRef = FirebaseDatabase.instance.ref();
    postListRef.child('Txt').push().set(i.toJson());
    listTxt.add(i);
    emit(state.copyWith(txts: listTxt, status: TxtStatus.success));
  }

  void xoaGhiChu(int index) {
    emit(state.copyWith(status: TxtStatus.start));
    DatabaseReference delete =
        FirebaseDatabase.instance.ref().child('Txt/${listTxt[index].key}');
    delete.remove();
    listTxt.removeAt(index);
    emit(state.copyWith(status: TxtStatus.success));
  }

  void hienThiGhiChu() async {
    try {
      emit(state.copyWith(status: TxtStatus.start));
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
