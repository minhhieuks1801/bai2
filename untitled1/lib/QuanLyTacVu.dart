import 'package:flutter/material.dart';


class QuanLyTacVu extends StatefulWidget{
  const QuanLyTacVu({super.key});
  @override
  _QuanLyTacVu1 createState() => _QuanLyTacVu1();
}


class _QuanLyTacVu1 extends State<QuanLyTacVu> {
  final TextEditingController _txtTenTask = TextEditingController();
  final TextEditingController _txtNoiDungTask = TextEditingController();


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
                        labelText: 'Tên tác vụ',
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
                        labelText: 'Nội dung tác vụ',
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
            Row(
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
                  child: const Text('Quản lý tác vụ',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );

  }

}