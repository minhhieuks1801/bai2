import 'package:flutter/material.dart';
import 'package:untitled1/ghiChuImg.dart';
import 'package:untitled1/ghiChuTxt.dart';
import 'package:untitled1/ghiChuSound.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final TextEditingController _txtGhi = TextEditingController();
  List<dynamic> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ghiChuTxt())
                );
              },
              child: const Text('Bản ghi text',
                style: TextStyle(fontSize: 15, color: Colors.lightBlue),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ghiChuImg())
                );
              },
              child: const Text('Bản ghi hình',
                style: TextStyle(fontSize: 15, color: Colors.lightBlue),

              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ghiChuSound())
                );
              },
              child: const Text('Bản ghi âm',
                style: TextStyle(fontSize: 15, color: Colors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
