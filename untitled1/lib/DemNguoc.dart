import 'dart:async';
import 'package:flutter/material.dart';

class DemNguoc extends StatefulWidget {
  const DemNguoc({super.key});

  @override
  _DongHo createState() => _DongHo();
}

class _DongHo extends State<DemNguoc> {
  Duration? thoiGian = Duration.zero;
  int? gio = 0, phut = 0, giay = 0;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Đếm ngược')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<int>(
                  menuMaxHeight: 200,
                  dropdownColor: Colors.black,
                  alignment: Alignment.center,
                  items: [
                    for(int i = 0; i< 24; i++)
                      DropdownMenuItem<int>(
                        value: i,
                        child: Text(i.toInt().toString(),
                          style: const TextStyle(fontSize: 25, color: Colors.red),
                        ),
                      ),
                  ],
                  onChanged: (int? newValue) {
                    setState(() {
                      gio = newValue;
                    });
                  },
                  value: gio,
                ),
                const Text('Giờ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                DropdownButton<int>(
                  menuMaxHeight: 200,
                  dropdownColor: Colors.black,
                  alignment: Alignment.center,
                  items: [
                    for(int i = 0; i< 60; i++)
                      DropdownMenuItem<int>(
                        value: i,
                        child: Text(i.toInt().toString(),
                          selectionColor: Colors.black,
                          style: const TextStyle(fontSize: 25, color: Colors.red),
                        ),
                      ),
                  ],
                  onChanged: (int? newValue) {
                    setState(() {
                      phut = newValue;
                    });
                  },
                  value: phut,
                ),
                const Text('Phút',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                DropdownButton<int>(
                  menuMaxHeight: 200,
                  dropdownColor: Colors.black,
                  alignment: Alignment.center,
                  items: [
                    for(int i = 0; i< 60; i++)
                      DropdownMenuItem<int>(
                        value: i,
                        child: Text(i.toInt().toString(),
                          selectionColor: Colors.black,
                          style: const TextStyle(fontSize: 25, color: Colors.red),
                        ),
                      ),
                  ],
                  onChanged: (int? newValue) {
                    setState(() {
                      giay = newValue;
                    });
                  },
                  value: giay,
                ),
                const Text('Giây',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  demNguoc();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Background color
                ),
                child: const Text('Nhập thời gian: ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatTime(thoiGian!),
                  style: const TextStyle(fontSize: 50, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration){
    String twoDigits (int n) => n.toString().padLeft(2, '0');
    String H = twoDigits(duration.inHours);
    String M = twoDigits(duration.inMinutes.remainder(60));
    String S = twoDigits(duration.inSeconds.remainder(60));
    return [if(duration.inHours > 0 )
      H, M, S].join(':');
  }

  void demNguoc() {
    int s = gio!* 3600 +phut!*60 + giay!;
    thoiGian = Duration(seconds: s);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (thoiGian!.inSeconds > 0) {
          thoiGian = (thoiGian! - const Duration(seconds: 1));
        } else {
          timer.cancel();
        }
      });
    });
  }
}