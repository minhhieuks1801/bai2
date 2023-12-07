import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DemNguoc extends StatefulWidget {
  const DemNguoc({super.key});

  @override
  _DongHo createState() => _DongHo();
}

class _DongHo extends State<DemNguoc> {
  Duration thoiGian = Duration.zero;
  int gio = 0, phut = 0, giay = 0;
  late Timer timer;
  bool a = false;

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
                Container(
                  height: 300,
                  width: 80,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: 0,
                    ),
                    children: [
                      for(int i = 0; i< 24; i++)
                        Text(i.toInt().toString(),
                          style: const TextStyle(fontSize: 35, color: Colors.amber),
                        )
                    ],
                    onSelectedItemChanged: (int value){
                      setState(() {
                        gio = value;
                      });
                    },
                  ),
                ),
                const Text('Giờ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Container(
                  height: 300,
                  width: 80,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: 0,
                    ),
                    children: [
                      for(int i = 0; i< 60; i++)
                        Text(i.toInt().toString(),
                          style: const TextStyle(fontSize: 35, color: Colors.amber),
                        )
                    ],
                    onSelectedItemChanged: (int value){
                      setState(() {
                        phut = value;
                      });

                    },
                  ),
                ),
                const Text('Phút',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Container(
                  height: 300,
                  width: 40,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: 0,
                    ),
                    children: [
                      for(int i = 0; i< 60; i++)
                        Text(i.toInt().toString(),
                          style: const TextStyle(fontSize: 35, color: Colors.amber),
                        ),
                    ],
                    onSelectedItemChanged: (int value){
                      setState(() {
                        giay = value;
                      });

                    },
                  ),
                ),
                const Text('Giây',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      demNguoc();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan, // Background color
                    ),
                    child: const Text('Chạy',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(!a){
                          timer.cancel();
                          a = true;
                        }
                        else{
                          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                            setState(() {
                              if (thoiGian.inSeconds > 0) {
                                thoiGian = (thoiGian - const Duration(seconds: 1));
                              } else {
                                timer.cancel();
                              }
                              a = false;
                            });
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan, // Background color
                    ),
                    child: !a? const Text('Dừng',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ):
                    const Text('Tiếp tục',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatTime(thoiGian),
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
    int s = gio* 3600 +phut*60 + giay;
    thoiGian = Duration(seconds: s);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (thoiGian.inSeconds > 0) {
          thoiGian = (thoiGian - const Duration(seconds: 1));
        } else {
          timer.cancel();
        }
      });
    });
  }
}