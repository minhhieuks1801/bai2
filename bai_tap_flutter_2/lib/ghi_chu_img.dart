import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled1/model/img.dart';
import 'package:logging/logging.dart';

class GhiChuImg extends StatefulWidget {
  const GhiChuImg({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GhiChuState();
}

class GhiChuState extends State<GhiChuImg> {
  Uint8List? imageBytes;
  Query ref = FirebaseDatabase.instance.ref();
  Query refAnh = FirebaseDatabase.instance.ref().child('img');
  List<Img> listAnh = [];
  bool delateSave = false;
  final Logger logger = Logger('');

  @override
  void initState() {
    hienThiAnh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ghi hình')),
      backgroundColor: Colors.greenAccent,
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Row(
              children: [
                IconButton(
                  onPressed: (){
                    layAnh();
                    },
                  iconSize: 60,
                  color: Colors.red,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                  ),
                  icon: const Icon(
                      Icons.add
                  ),
                ),
                if (imageBytes != null && !delateSave == false)
                  Row(
                    children: [
                      Image.memory(
                        fit: BoxFit.fill,
                        imageBytes!,
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: luuAnh,
                            child: const Text('Lưu'),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                delateSave = false;
                              });
                            },
                            child: const Text('Hủy'),
                          ),
                        ],
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
                        margin: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffF4E869),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (listAnh[index].link == '') ? const Text('loading!') :
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 12),
                              child: Image.network(
                                listAnh[index].link.toString(),
                                fit: BoxFit.fill,
                                height: 120,
                                width: 120,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  listAnh[index].name.toString().substring(
                                      0, listAnh[index].name.toString().length - 4),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.red),
                                ),
                                IconButton(
                                  onPressed:(){
                                    xemImgDialog(context, listAnh[index].link.toString());
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
                    }),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> layAnh() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imageBytes1 = await imageFile.readAsBytes();
      setState(() {
        imageBytes = imageBytes1;
        delateSave = true;
      });
    }
  }

  Future<void> luuAnh() async {
    try {
      if (imageBytes != null) {
        String imageName = DateTime.now().toString().split('.')[0];
        final firebaseStorage =
            FirebaseStorage.instance.ref().child('$imageName.PNG');
        firebaseStorage.putData(imageBytes!);
        Img i = Img(key: imageName, name: '$imageName.PNG', link: '');
        DatabaseReference postListRef = FirebaseDatabase.instance.ref();
        postListRef.child('Img').push().set(i.toJson());
        setState(() {
          Future.delayed(const Duration(seconds: 2), () {
            hienThiAnh();
          });
          delateSave = false;
        });
      }
    } catch (error) {
      logger.warning('Lỗi : $error');
    }
  }

  Future<void> hienThiAnh() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Img').orderByChild('name')/*reference().child('img')*/;
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        listAnh.clear();
        values.forEach((key, item) {
          setState(() {
            listAnh.add(Img(key: key, name: item['name'].toString(), link: ''));
            layAnhFireBase(item['name'].toString());
          });
        });
      }, onError: (error) {
      });
    } catch(error){
      logger.warning('Lỗi : $error');
    }
  }

  Future<void> layAnhFireBase(String tenAnh) async{
    Reference ref = FirebaseStorage.instance.ref().child(tenAnh);
    String url = await ref.getDownloadURL();
    setState(() {
      listAnh.setAll(listAnh.indexWhere((img) => img.name == tenAnh),
        listAnh.where((img) => img.name == tenAnh)
            .map((img) => img.copyWith(key: img.key, link: url, name: img.name)).toList(),
      );
    });

  }

  Future<void> xoaAnh(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance.ref().child('Img/${listAnh[index].key}');
    deleteFB.remove();

    final desertRef = FirebaseStorage.instance.ref().child(listAnh[index].name.toString());
    await desertRef.delete();
    setState(() {
      Future.delayed(const Duration(seconds: 2), () {
        //listAnh.removeAt(index);
        hienThiAnh();
      });
    });
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
                  xoaAnh(index);
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

}
