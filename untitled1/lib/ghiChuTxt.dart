import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ghiChuTxt extends StatefulWidget{
  const ghiChuTxt({super.key});
  @override
  _ghiChu1 createState() => _ghiChu1();
}


class _ghiChu1 extends State<ghiChuTxt> {
  final TextEditingController _txtGhi = TextEditingController();
  List<String> list = [];

  @override
  Widget build(BuildContext context) {
    duyet();
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                _nhapTextDialog(context);
              },
              child: const Text('Thêm',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            for(int i = 0; i < list.length; i++)
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
                      child: Text(list[i].toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        _xemTextDialog(context, list[i].toString());
                      },
                      child: const Text('Xem'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        list.remove(list[i]);
                        setState(() {});
                      },
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

  _getSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listitems = prefs.getStringList('items');
    list = listitems!;
    setState(() {});
  }

  void duyet(){
    _getSP();
    setState(() {});
  }

  _setSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', list);
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
                  list.add(_txtGhi.text);
                  _setSP();
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
                child: Text(a)
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