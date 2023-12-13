import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/cubit/img_cubit.dart';
import 'package:untitled1/cubit/img_state.dart';

class ImgViewList extends StatefulWidget {
  const ImgViewList({super.key});

  @override
  ImgViewState createState() => ImgViewState();
}

class ImgViewState extends State<ImgViewList> {
  late ImgCubit cubit;
  Uint8List? imageBytes;
  bool delateSave = false;

  @override
  void initState() {
    cubit = context.read<ImgCubit>();
    cubit.hienThiAnh();
    super.initState();
  }

  void layAnh() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú hình'),
      ),
      body: Center(
          child: BlocBuilder<ImgCubit, ImgState>(
            builder: (context, listAnh) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: layAnh,
                        iconSize: 60,
                        color: Colors.red,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                        ),
                        icon: const Icon(Icons.add),
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
                                  onPressed: () {
                                    cubit.luuAnh(imageBytes);
                                    setState(() {
                                      delateSave = false;
                                    });

                                  },
                                  child: const Text('Lưu'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
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
                        itemCount: listAnh.imgs.length,
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
                                (listAnh.imgs[index].link == '')
                                    ? const Text('loading!')
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            top: 12,
                                            right: 0,
                                            bottom: 12),
                                        child: Image.network(
                                          listAnh.imgs[index].link.toString(),
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 120,
                                        ),
                                      ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      listAnh.imgs[index].name
                                          .toString()
                                          .substring(
                                              0,
                                              listAnh.imgs[index].name
                                                      .toString()
                                                      .length -
                                                  4),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        xemImgDialog(
                                            context,
                                            listAnh.imgs[index].link
                                                .toString());
                                      },
                                      iconSize: 32,
                                      icon: const Icon(Icons.visibility),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        xoaImgDialog(
                                          context,
                                          index,
                                          () {
                                            cubit.xoaAnh(index);
                                          },
                                        );
                                      },
                                      iconSize: 32,
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  xoaImgDialog(BuildContext context, int index, VoidCallback callback) async {
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
                  callback.call();
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
