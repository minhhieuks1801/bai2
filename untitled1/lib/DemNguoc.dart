import 'dart:async';

import 'package:flutter/material.dart';

class DemNguoc extends StatefulWidget {
  const DemNguoc({super.key});

  @override
  _DongHo createState() => _DongHo();
}

class _DongHo extends State<DemNguoc> {
  double? htPhut = 0, htGiay = 0;
  double? a1 = 0, a2 = 0;
  final TextEditingController phutController = TextEditingController();
  final TextEditingController giayController = TextEditingController();
  late Timer timer;
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      demNguoc();
                    },
                    child: Text('Nhập thời gian: ')
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<double>(
                  menuMaxHeight: 100,
                  items: [
                    for(double i = 0; i< 60; i++)
                      DropdownMenuItem<double>(
                        value: i,
                        child: Text(i.toInt().toString(),
                          style: const TextStyle(fontSize: 20, color: Colors.black),),
                      ),
                  ],
                  onChanged: (double? newValue) {
                    setState(() {
                      a1 = newValue;
                    });
                  },
                  value: a1,
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton<double>(
                  menuMaxHeight: 100,
                  items: [
                    for(double i = 0; i< 60; i++)
                      DropdownMenuItem<double>(
                        value: i,
                        child: Text(i.toInt().toString(),
                          style: const TextStyle(fontSize: 20, color: Colors.black),),
                      ),
                  ],
                  onChanged: (double? newValue) {
                    setState(() {
                      a2 = newValue;
                    });
                  },
                  value: a2,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Đếm '),
                const SizedBox(
                  width: 10,
                ),
                Text(htPhut!.toInt().toString(),
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
                const Text(' : '),
                Text(htGiay!.toInt().toString(),
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void demNguoc() {
    double thoigianGiay = (a1!*60 + a2!);
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (Timer timer) {
      if (thoigianGiay == 0) {
        timer.cancel();
      } else {
        setState(() {
          thoigianGiay--;
          htPhut = thoigianGiay/60;
          htGiay = thoigianGiay%60;
        });
      }
    });
  }
}