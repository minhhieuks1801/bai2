import 'package:flutter/material.dart';
import 'package:untitled1/DemNguoc.dart';
import 'package:untitled1/QuanLyTacVu.dart';
import 'package:untitled1/ghiChuImg.dart';
import 'package:untitled1/ghiChuTxt.dart';
import 'package:untitled1/ghiChuSound.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/XemThoiTiet.dart';
import 'firebase_options.dart';
 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: bai2_firebase(),
    title: 'bai2',
  ));
}

class bai2_firebase extends StatefulWidget{
  const bai2_firebase({super.key});
  @override
  _ghiChu createState() => _ghiChu();
}

class _ghiChu extends State<bai2_firebase> {
  List<dynamic> list = [];
  late ThoiTietApi thoiTietApi = ThoiTietApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ghiChuTxt())
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, // Background color
                ),
                child: const Text('Bản ghi text',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ghiChuImg())
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, // Background color
                ),
                child: const Text('Bản ghi hình',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ghiChuSound())
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, // Background color
                ),
                child: const Text('Bản ghi âm',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => XemThoiTiet(thoitietApi: thoiTietApi,))
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, // Background color
                ),
                child: const Text('Xem thời tiết',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DemNguoc())
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, // Background color
                ),
                child: const Text('Đếm ngược',
                  style: TextStyle(fontSize: 15, color: Colors.black),
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
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
