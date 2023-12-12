
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:untitled1/cubit/txt_cubit.dart';
//import 'package:untitled1/model/txt.dart';

class GhiTxtView extends StatefulWidget {
  const GhiTxtView({super.key});

  @override
  TxtViewState createState() => TxtViewState();
}

class TxtViewState extends State<GhiTxtView> {
  late TxtCubit cubit;
  final TextEditingController txtGhi = TextEditingController();
  final Logger logger = Logger('');

  @override
  void initState() {
    cubit = context.read<TxtCubit>();
    cubit.hienThiGhiChu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Ghi văn bản')),
      body: Center(
        child: BlocBuilder<TxtCubit, TxtState>(
          builder: (context, listTxt) => Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => nhapTextDialog(context, (){
                    cubit.nhapGhiChu(txtGhi.text.toString());
                    setState(() {
                      txtGhi.text = '';
                    });
                  }),
                  child: const Text(
                    'Thêm',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: listTxt.txts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(listTxt.txts[index].name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                            const Expanded(child: SizedBox()),
                            ElevatedButton(
                              onPressed: () {
                                xemTextDialog(context,
                                    listTxt.txts[index].name.toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.lightGreenAccent, // Background color
                              ),
                              child: const Text('Xem'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                xoaImgDialog(context, index, () {
                                  cubit.xoaGhiChu(index);
                                });
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.lightGreenAccent, // Background color
                              ),
                              child: const Text('Xóa'),
                            ),
                          ],
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

  nhapTextDialog(BuildContext context, VoidCallback callback) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: txtGhi,
              decoration: const InputDecoration(hintText: "Nhập nội dung"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Nhập'),
                onPressed: () {
                  callback.call();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  xemTextDialog(BuildContext context, String a) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Scrollbar(
                child: Text(
              a,
              style: const TextStyle(fontSize: 25, color: Colors.black),
            )),
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

  xoaImgDialog(BuildContext context, int index, VoidCallback callback) async {
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
}
