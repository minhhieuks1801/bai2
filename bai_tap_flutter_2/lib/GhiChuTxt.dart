import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'model/Txt.dart';

class ghiChuTxt extends StatefulWidget{
  const ghiChuTxt({super.key});
  @override
  _ghiChu1 createState() => _ghiChu1();
}


class _ghiChu1 extends State<ghiChuTxt> {
  final TextEditingController _txtGhi = TextEditingController();
  List<Txt> listTxt = [];

  @override
  void initState() {
    _hienThiGhiChu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Ghi văn bản')),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                _nhapTextDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent, // Background color
              ),
              child: const Text('Thêm',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            for(int i = 0; i < listTxt.length; i++)
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      child: Text(listTxt[i].name.toString(),
                        overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 20, color: Colors.white)
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        _xemTextDialog(context, listTxt[i].name.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreenAccent, // Background color
                      ),
                      child: const Text('Xem'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _xoaImgDialog(context ,i);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreenAccent, // Background color
                      ),
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  _nhapTextDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _txtGhi,
              decoration: const InputDecoration(hintText: "Nhập nội dung"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Nhập'),
                onPressed: () {
                  Navigator.of(context).pop();
                  String imageName = DateTime.now().toString().split('.')[0];
                  Txt i = Txt(imageName, _txtGhi.text.toString());
                  DatabaseReference postListRef = FirebaseDatabase.instance.reference();
                  postListRef.child('Txt').push().set(i.toJson());
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  _xemTextDialog(BuildContext context, String a) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Scrollbar(
                child: Text(a,
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                )
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Canel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  _xoaImgDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Scrollbar(
              child: Text('Bạn có muốn xóa ghi chú không?'),
            ),
            actions: <Widget>[

              ElevatedButton(
                onPressed: () {
                  _xoaGhiChu(index);
                  Navigator.of(context).pop();
                },
                child: const Text('Có'),
              ),

              ElevatedButton(
                child: const Text('Canel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _xoaGhiChu(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance.reference().child('Txt/${listTxt[index].key}');
    deleteFB.remove();
    setState(() {
      listTxt.removeAt(index);
      Future.delayed(const Duration(seconds: 2), () {
      });
    });
  }


  Future<void> _hienThiGhiChu() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Txt').orderByChild('name')/*reference().child('img')*/;
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        listTxt.clear();
        values.forEach((key, item) {
          setState(() {
            listTxt.add(Txt(key, item['name'].toString()));
          });
        });
      }, onError: (error) {
      });
    } catch(e){
      print(e);
    }
  }
}