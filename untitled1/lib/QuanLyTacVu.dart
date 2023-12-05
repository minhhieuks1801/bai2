import 'package:flutter/material.dart';
import 'package:untitled1/model/TacVu.dart';


class QuanLyTacVu extends StatefulWidget{
  const QuanLyTacVu({super.key});
  @override
  _QuanLyTacVu1 createState() => _QuanLyTacVu1();
}


class _QuanLyTacVu1 extends State<QuanLyTacVu> {
  final TextEditingController _txtTenTask = TextEditingController();
  final TextEditingController _txtNoiDungTask = TextEditingController();
  List<TacVu> listTacVu = [TacVu('001', 'Tác vụ 1', 'Hoàn thành app tác vũ', false)];
  bool? light;

  _xoaImgDialog(BuildContext context) async {
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
                        labelStyle: TextStyle(fontSize: 20, color: Colors.grey)
                    ),
                  ),
                  TextField(
                    controller: _txtNoiDungTask,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    maxLines: 5,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        //contentPadding: EdgeInsets.symmetric(vertical: 40),
                        labelText: 'Nội dung',
                        labelStyle: TextStyle(fontSize: 20, color: Colors.grey)
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Lưu'),
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
                ElevatedButton(
                  onPressed: () {
                    _xoaImgDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent, // Background color
                  ),
                  child: const Text('Thêm tác vụ',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuanLyTacVu())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent, // Background color
                  ),
                  child: const Text('Tác vụ chưa hoàn thành',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: listTacVu.length,
                  itemBuilder: (BuildContext context, int index){
                    light = listTacVu[index].tinhTrang;
                    return Container(
                      color: const Color(0xffF4E869),
                      height: 100,
                      margin: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.3,
                            child: Text(listTacVu[index].tieuDe.toString(),
                              style: const TextStyle(fontSize: 20, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Switch(
                            value: listTacVu[index].tinhTrang,
                            thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                            onChanged: (bool value) {
                              setState(() {
                                light = value;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                            },
                            child: const Text('Xem'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Xóa'),
                          ),

                        ],
                      ),
                    );
                  }
                ),
            ),
          ],
        ),
      )
    );

  }

}