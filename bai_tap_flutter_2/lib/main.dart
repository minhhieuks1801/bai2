import 'package:flutter/material.dart';
import 'package:untitled1/dem_nguoc.dart';
import 'package:untitled1/ghi_chu_img_cubit.dart';
import 'package:untitled1/ghi_chu_sound.dart';
import 'package:untitled1/quan_ly_tac_vu.dart';
import 'package:untitled1/ghi_chu_img.dart';
import 'package:untitled1/ghi_chu_txt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/xem_thoi_tiet.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: Bai2(),
    title: 'bai2',
  ));
}

class Bai2 extends StatefulWidget {
  const Bai2({super.key});

  @override
  TrangChu createState() => TrangChu();
}

class TrangChu extends State<Bai2> {
  List<dynamic> list = [];
  late ThoiTietApi thoiTietApi = ThoiTietApi();

  @override
  void initState() {
    thoiTietApi = ThoiTietApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GhiChuTxt()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Background color
              ),
              child: const Text(
                'Bản ghi text',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GhiHinhImgCubit()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Background color
              ),
              child: const Text(
                'Bản ghi hình',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GhiChuSound()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Background color
              ),
              child: const Text(
                'Bản ghi âm',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => XemThoiTiet(
                              thoitietApi: thoiTietApi,
                            )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Background color
              ),
              child: const Text(
                'Xem thời tiết',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DemNguoc()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Background color
              ),
              child: const Text(
                'Đếm ngược',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuanLyTacVu()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Background color
              ),
              child: const Text(
                'Quản lý tác vụ',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
