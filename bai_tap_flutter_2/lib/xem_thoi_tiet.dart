import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class XemThoiTiet extends StatefulWidget{
  final ThoiTietApi thoitietApi;

  const XemThoiTiet({super.key, required this.thoitietApi});

  @override
  State<StatefulWidget> createState() => XemThoiTietState();
}


class XemThoiTietState extends State<XemThoiTiet> {

  late Future<Map<String, dynamic>> data;
  double? lat = 21.028333;
  double? lon = 105.853333;
  final TextEditingController txtThanhPho = TextEditingController();
  final Logger logger = Logger('');

  @override
  void initState() {
    super.initState();
    data = widget.thoitietApi.getWeather(lat!, lon!);
  }

  Future<void> getCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(txtThanhPho.text);
      if (locations.isNotEmpty) {
        setState(() {
          lat = locations[0].latitude;
          lon = locations[0].longitude;
          data = widget.thoitietApi.getWeather(lat!, lon!);
        });
      } else {
      }
    } catch (e) {
      logger.warning('Lỗi : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem thời tiết')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 200,
            margin: const EdgeInsets.only(left: 50, top: 0, right: 50, bottom: 25),
            child: TextField(controller: txtThanhPho,
              style: const TextStyle(fontSize: 25, color: Colors.black),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tên thành phố',
                labelStyle: TextStyle(fontSize: 25, color: Colors.grey)
              ),
            ),
          ),
          ElevatedButton(
              onPressed: (){
                getCoordinates();
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent, // Background color
            ),
              child: const Text('Chọn thành phố',
                  style: TextStyle(fontSize: 25, color: Colors.black)
              ),
          ),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final weatherInfo = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Nhiệt độ: ${weatherInfo['main']['temp']}°C',
                          style: const TextStyle(fontSize: 25, color: Colors.black)),
                      Text('Độ ẩm: ${weatherInfo['main']['humidity']}%',
                          style: const TextStyle(fontSize: 25, color: Colors.black)),
                      Text('Tốc độ gió: ${weatherInfo['wind']['speed']} m/s',
                          style: const TextStyle(fontSize: 25, color: Colors.black)),
                      Text('Miêu tả: ${weatherInfo['weather'][0]['description']}',
                          style: const TextStyle(fontSize: 25, color: Colors.black)),
                    ],
                  );
                }
              },
            ),
          ),
        ],

      ),
    );
  }
}

class ThoiTietApi {
  final String apiKey;

  ThoiTietApi({this.apiKey = 'cb12b70159fca67befcc8611bb050256'});

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=vi'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Không lấy được dữ liệu');
    }
  }
}