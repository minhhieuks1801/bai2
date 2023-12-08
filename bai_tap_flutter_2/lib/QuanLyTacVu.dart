import 'package:flutter/material.dart';
import 'package:untitled1/model/TacVu.dart';
import 'package:firebase_database/firebase_database.dart';

class QuanLyTacVu extends StatefulWidget {
  const QuanLyTacVu({super.key});

  @override
  _QuanLyTacVu1 createState() => _QuanLyTacVu1();
}

class _QuanLyTacVu1 extends State<QuanLyTacVu> {
  final TextEditingController _txtTenTask = TextEditingController();
  final TextEditingController _txtNoiDungTask = TextEditingController();
  List<TacVu> listTacVu = [];

  @override
  void initState() {
    _hienThiTacVu();
    super.initState();
  }

  Future<void> _hienThiTacVu() async {
    try {
      Query refAnh =
          FirebaseDatabase.instance.ref('TacVu').orderByChild('tieuDe');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        listTacVu.clear();
        values.forEach((key, item) {
          setState(() {
            print(item['tinhTrang']);
            listTacVu.add(TacVu(key, item['tieuDe'].toString(),
                item['noiDung'].toString(), item['tinhTrang']));
          });
        });
      }, onError: (error) {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _hienThiTacVuChuaHoanThanh() async {
    try {
      Query refAnh =
          FirebaseDatabase.instance.ref('TacVu').orderByChild('tieuDe');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        listTacVu.clear();
        values.forEach((key, item) {
          setState(() {
            if (item['tinhTrang'] == false) {
              listTacVu.add(TacVu(key, item['tieuDe'].toString(),
                  item['noiDung'].toString(), item['tinhTrang']));
            }
          });
        });
      }, onError: (error) {});
    } catch (e) {
      print(e);
    }
  }

  _ThemTacVuDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 400,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: _txtTenTask,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tiêu đề',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  TextField(
                    controller: _txtNoiDungTask,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        //contentPadding: EdgeInsets.symmetric(vertical: 40),
                        labelText: 'Nội dung',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  TacVu t = TacVu('', _txtTenTask.text.toString(),
                      _txtNoiDungTask.text.toString(), false);
                  DatabaseReference postListRef =
                      FirebaseDatabase.instance.reference();
                  postListRef.child('TacVu').push().set(t.toJson());
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Lưu'),
              ),
              ElevatedButton(
                child: const Text('Thoát'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _SuaTacVuDialog(BuildContext context, int index) async {
    final TextEditingController _txtSuaTen =
        TextEditingController(text: listTacVu[index].tieuDe.toString());
    final TextEditingController _txtSuaNoiDUng =
        TextEditingController(text: listTacVu[index].noiDung.toString());
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 400,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: _txtSuaTen,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tiêu đề',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  TextField(
                    controller: _txtSuaNoiDUng,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        //contentPadding: EdgeInsets.symmetric(vertical: 40),
                        labelText: 'Nội dung',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Text(
                    'Tình trạng: ${listTacVu[index].tinhTrang ? 'Đã hoàn thành' : 'Chưa hoàn thành'}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  listTacVu[index].tieuDe = _txtSuaTen.text.toString();
                  listTacVu[index].noiDung = _txtSuaNoiDUng.text.toString();
                  DatabaseReference postListRef =
                      FirebaseDatabase.instance.reference();
                  postListRef
                      .child('TacVu/${listTacVu[index].key}')
                      .update(listTacVu[index].toJson());
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Lưu'),
              ),
              ElevatedButton(
                child: const Text('Thoát'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _xoaTacVuDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Scrollbar(
              child: Text('Bạn có muốn xóa tác vụ không?'),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _xoaTacVu(index);
                  Navigator.of(context).pop();
                },
                child: const Text('Có'),
              ),
              ElevatedButton(
                child: const Text('Thoát'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _xoaTacVu(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance
        .reference()
        .child('TacVu/${listTacVu[index].key}');
    deleteFB.remove();
    setState(() {
      listTacVu.removeAt(index);
      Future.delayed(const Duration(seconds: 2), () {
        _hienThiTacVu();
      });
    });
  }

  Future<void> _UpdateFirebase(int index) async {
    DatabaseReference postListRef = FirebaseDatabase.instance.reference();
    postListRef
        .child('TacVu/${listTacVu[index].key}')
        .update(listTacVu[index].toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Quản lý tác vụ')),
        body: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          _ThemTacVuDialog(context);
                        },
                        iconSize: 30,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        icon: const Icon(Icons.add),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _hienThiTacVu();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent, // Background color
                        ),
                        child: const Text(
                          'Tất cả',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _hienThiTacVuChuaHoanThanh();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent, // Background color
                        ),
                        child: const Text(
                          'Chưa hoàn thành',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: listTacVu.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 100,
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffF4E869),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                listTacVu[index].tieuDe.toString(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Switch(
                              value: listTacVu[index].tinhTrang,
                              thumbColor: const MaterialStatePropertyAll<Color>(
                                  Colors.red),
                              onChanged: (bool value) {
                                setState(() {
                                  if (value) {
                                    listTacVu[index].tinhTrang = true;
                                    _UpdateFirebase(index);
                                  } else {
                                    listTacVu[index].tinhTrang = false;
                                    _UpdateFirebase(index);
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _SuaTacVuDialog(context, index);
                              },
                              child: const Text('Xem'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _xoaTacVuDialog(context, index);
                              },
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
