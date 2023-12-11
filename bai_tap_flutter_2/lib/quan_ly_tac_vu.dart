import 'package:flutter/material.dart';
import 'package:untitled1/model/tac_vu.dart';
import 'package:firebase_database/firebase_database.dart';

class QuanLyTacVu extends StatefulWidget {
  const QuanLyTacVu({super.key});

  @override
  QuanLyTacVuState createState() => QuanLyTacVuState();
}

class QuanLyTacVuState extends State<QuanLyTacVu> {
  final TextEditingController txtTenTask = TextEditingController();
  final TextEditingController txtNoiDungTask = TextEditingController();
  List<TacVu> listTacVu = [], listTacVu1 = [];

  @override
  void initState() {
    hienThiTacVu();
    super.initState();
  }

  Future<void> hienThiTacVu() async {
    try {
      Query refAnh =
          FirebaseDatabase.instance.ref('TacVu').orderByChild('tieuDe');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        listTacVu.clear();
        values.forEach((key, item) {
          setState(() {
            listTacVu.add(TacVu(key: key, tieuDe: item['tieuDe'].toString(),
                noiDung: item['noiDung'].toString(), tinhTrang: item['tinhTrang']));
          });
        });
      }, onError: (error) {});
    } catch (e) {
    }
  }

  Future<void> hienThiTacVuChuaHoanThanh() async {
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
              listTacVu.add(TacVu(key: key, tieuDe: item['tieuDe'].toString(),
                  noiDung: item['noiDung'].toString(), tinhTrang: item['tinhTrang']));
            }
          });
        });
      }, onError: (error) {});
    } catch (e) {
    }
  }

  themTacVuDialog(BuildContext context) async {
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
                    controller: txtTenTask,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tiêu đề',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  TextField(
                    controller: txtNoiDungTask,
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
                  TacVu t = TacVu(key: '', tieuDe: txtTenTask.text.toString(),
                      noiDung: txtNoiDungTask.text.toString(), tinhTrang: false);
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

  suaTacVuDialog(BuildContext context, int index) async {
    final TextEditingController txtSuaTen =
        TextEditingController(text: listTacVu[index].tieuDe.toString());
    final TextEditingController txtSuaNoiDUng =
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
                    controller: txtSuaTen,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tiêu đề',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  TextField(
                    controller: txtSuaNoiDUng,
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
                  TacVu tv =  listTacVu[index].copyWith(key: listTacVu[index].key,
                      tinhTrang: listTacVu[index].tinhTrang,
                      tieuDe: txtSuaTen.text.toString(),
                      noiDung: txtSuaNoiDUng.text.toString()
                  );
                  DatabaseReference postListRef =
                      FirebaseDatabase.instance.reference();
                  postListRef
                      .child('TacVu/${listTacVu[index].key}')
                      .update(tv.toJson());
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

  xoaTacVuDialog(BuildContext context, int index) async {
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
                  xoaTacVu(index);
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

  Future<void> xoaTacVu(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance
        .reference()
        .child('TacVu/${listTacVu[index].key}');
    deleteFB.remove();
    setState(() {
      listTacVu.removeAt(index);
      Future.delayed(const Duration(seconds: 2), () {
        hienThiTacVu();
      });
    });
  }

  Future<void> updateFirebase(int index, bool a) async {
    TacVu tv = listTacVu[index].copyWith(tinhTrang: a, tieuDe: listTacVu[index].tieuDe,
    noiDung: listTacVu[index].noiDung, key: listTacVu[index].key);
    DatabaseReference postListRef = FirebaseDatabase.instance.reference();
    postListRef
        .child('TacVu/${tv.key}')
        .update(tv.toJson());
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
                          themTacVuDialog(context);
                        },
                        iconSize: 30,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        icon: const Icon(Icons.add),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          hienThiTacVu();
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
                          hienThiTacVuChuaHoanThanh();
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
                                    bool a = true;
                                    updateFirebase(index, a);
                                  } else {
                                    bool a = false;
                                    updateFirebase(index, a);
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                suaTacVuDialog(context, index);
                              },
                              child: const Text('Xem'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                xoaTacVuDialog(context, index);
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
