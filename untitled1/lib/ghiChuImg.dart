import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:untitled1/model/Img.dart';

class ghiChuImg extends StatefulWidget {
  const ghiChuImg({super.key});

  @override
  _ghiChu2 createState() => _ghiChu2();
}

class _ghiChu2 extends State<ghiChuImg> {
  Uint8List? _imageBytes;
  Query ref = FirebaseDatabase.instance.ref();
  Query refAnh = FirebaseDatabase.instance.ref().child('img');
  List<Img> listAnh = [];
  bool delateSave = false;

  @override
  void initState() {
    _hienThiAnh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ghi hình')),
      backgroundColor: Colors.greenAccent,
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _layAnh,
                  child: const Text('Lấy ảnh'),
                ),
                if (_imageBytes != null && !delateSave == false)
                  Row(
                    children: [
                      Image.memory(
                        _imageBytes!,
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: _luuAnh,
                        child: const Text('Lưu'),
                      )
                    ],
                  ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: listAnh.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: const Color(0xffF4E869),
                        margin: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (listAnh[index].link == '') ? const Text('loading!') :
                            Image.network(
                              listAnh[index].link.toString(),
                              height: 200,
                              width: 100,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  listAnh[index].name.toString().substring(
                                      0, listAnh[index].name.toString().length - 4),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed:(){
                                    _xemImgDialog(context, listAnh[index].link.toString());
                                  },
                                  child: const Text('Xem ảnh'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed:(){
                                    _xoaImgDialog(context, index);
                                  },
                                  child: const Text('Xóa ảnh'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> _layAnh() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
        delateSave = true;
      });
    }
  }

  Future<void> _luuAnh() async {
    try {
      if (_imageBytes != null) {
        String imageName = DateTime.now().toString().split('.')[0];
        final firebaseStorage =
            FirebaseStorage.instance.ref().child('$imageName.PNG');
        firebaseStorage.putData(_imageBytes!);
        Img i = Img(imageName, '$imageName.PNG', '');
        DatabaseReference postListRef = FirebaseDatabase.instance.reference();
        postListRef.child('Img').push().set(i.toJson());
        setState(() {
          Future.delayed(const Duration(seconds: 2), () {
            _hienThiAnh();
          });

          delateSave = false;
        });
      }
    } catch (error) {}
  }

  Future<void> _hienThiAnh() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Img').orderByChild('name')/*reference().child('img')*/;
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        listAnh.clear();
        values.forEach((key, item) {
          setState(() {
            listAnh.add(Img(key, item['name'].toString(), ''));
            layAnhFireBase(item['name'].toString());
          });
        });
      }, onError: (error) {
      });
    } catch(e){
      print(e);
    }
  }

  Future<void> layAnhFireBase(String tenAnh) async{
    Reference ref = FirebaseStorage.instance.ref().child(tenAnh);
    String url = await ref.getDownloadURL();
    listAnh.forEach((img) {
      if(img.name == tenAnh){
        setState(() {
          img.link = url;
        });
      }
    });
  }

  Future<void> _xoaAnh(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance.reference().child('Img/${listAnh[index].key}');
    deleteFB.remove();

    final desertRef = FirebaseStorage.instance.ref().child(listAnh[index].name.toString());
    await desertRef.delete();
    setState(() {
      listAnh.removeAt(index);
      Future.delayed(const Duration(seconds: 2), () {
        _hienThiAnh();
      });
    });
  }

  _xoaImgDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Scrollbar(
              child: Text('Bạn có muốn xóa ảnh không?'),
            ),
            actions: <Widget>[

              ElevatedButton(
                onPressed: () {
                  _xoaAnh(index);
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

  _xemImgDialog(BuildContext context, String a) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Scrollbar(
                child: Image.network(
                  a,
                  height: 400,
                  width: 200,
                ),
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

}
