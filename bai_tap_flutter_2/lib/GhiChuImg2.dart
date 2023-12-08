import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled1/model/Img.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GhiChuImg2 extends StatefulWidget {
  const GhiChuImg2({Key? key}) : super(key: key);

  @override
  GhiChuState2 createState() => GhiChuState2();
}

class GhiChuState2 extends State<GhiChuImg2> {

  @override
  void initState() {

    super.initState();
  }

  xoaImgDialog(BuildContext context, int index) async {
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

  xemImgDialog(BuildContext context, String a) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Scrollbar(
              child: Image.network(
                a,
                fit: BoxFit.fill,
                height: 300,
                width: 300,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ghi hình')),
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xffF4E869),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 12),
                      child: Image.network(
                        'https://i1-dulich.vnecdn.net/2021/07/16/1-1626437591.jpg?w=1200&h=0&q=100&dpr=2&fit=crop&s=6lpdhgxgTYcbVie7Z_Hm0g',
                        fit: BoxFit.fill,
                        height: 120,
                        width: 120,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Hello kity',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.red),
                        ),
                        IconButton(
                          onPressed:(){

                          },
                          iconSize: 32,
                          icon: const Icon(
                              Icons.visibility
                          ),
                        ),
                        IconButton(
                          onPressed:(){
                            xoaImgDialog(context, index);
                          },
                          iconSize: 32,
                          icon: const Icon(
                              Icons.delete
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
    
  }
}

class XuLyAnh extends Cubit<List<Img>> {
  XuLyAnh() : super([]);
  Uint8List? imageBytes;
  Query ref = FirebaseDatabase.instance.ref();
  Query refAnh = FirebaseDatabase.instance.ref().child('img');
  List<Img> listAnh = [];
  bool delateSave = false;

  Future<void> hienThiAnh() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Img').orderByChild('name');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        listAnh.clear();
        values.forEach((key, item) {
            listAnh.add(Img(key: key, name: item['name'].toString(), link: ''));
            layAnhFireBase(item['name'].toString());
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
    listAnh.where((s) => s.name == tenAnh).forEach((s) {
        s = Img(key: s.key, name: s.name, link: url);
    });
  }



}
