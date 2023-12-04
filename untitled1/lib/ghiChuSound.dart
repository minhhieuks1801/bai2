import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter_sound/flutter_sound.dart';
import 'package:record/record.dart';
import 'package:path/path.dart';
import 'package:audioplayers/audioplayers.dart' show PlayerState;




import 'model/Img.dart';

class ghiChuSound extends StatefulWidget{
  const ghiChuSound({super.key});
  @override
  _ghiChuSound1 createState() => _ghiChuSound1();
}

class _ghiChuSound1 extends State<ghiChuSound> with TickerProviderStateMixin {
  int? a = 0, b = 0;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String? audioPath = '';
  List<Img> listItem = [];
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    _hienThiFile();
    audioRecord = Record();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if(await audioRecord.hasPermission()){
      await audioRecord.start();
    }

    setState(() {
      isRecording = true;
    });
  }
  Future<void> stopRecording() async {
    //Kết nối máy thật hoặc máy ảo bên ngoài để lấy mic :v
    String? path = await audioRecord.stop();
    audioPath = path!;
    uploadFile();
    setState(() {
      isRecording = false;
    });
  }
  Future<void> playRecording(int index) async {
    Reference ref = FirebaseStorage.instance.ref().child(listItem[index].name.toString());
    String url = await ref.getDownloadURL();
    Source path = UrlSource(url);
    await audioPlayer.play(path);
    setState(() {});
  }
  Future<void> pauseRecording() async {
    audioPlayer.pause();
    setState(() {});
  }
  Future<void> uploadFile() async {
    File file = File(audioPath!);
    //String fileName = file.path.split('/').last;

    String name = DateTime.now().toString().split('.')[0];
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('$name.M4A');
      Img i = Img(name, '$name.M4A', 2, '');
      DatabaseReference postListRef = FirebaseDatabase.instance.reference();
      postListRef.child('Img').push().set(i.toJson());
      // Tải lên tệp M4A
      await storageReference.putFile(
        file,
        SettableMetadata(contentType: 'audio/m4a'), //
      );
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
  Future<void> _hienThiFile() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Img').orderByChild('name')/*reference().child('img')*/;
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        listItem.clear();
        values.forEach((key, item) {
          setState(() {
            if(item['type'] == 2){
              listItem.add(Img(key, item['name'].toString(), item['type'], ''));
              layFileFireBase(item['name'].toString());
            }
          });
        });
      }, onError: (error) {
      });
    } catch(e){
      print(e);
    }
  }
  Future<void> layFileFireBase(String tenAnh) async{
    Reference ref = FirebaseStorage.instance.ref().child(tenAnh);
    String url = await ref.getDownloadURL();
    listItem.forEach((img) {
      if(img.name == tenAnh){
        setState(() {
          img.link = url;
        });
      }
    });
  }
  Future<void> _xoaAnh(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance.reference().child('Img/${listItem[index].key}');
    deleteFB.remove();

    final desertRef = FirebaseStorage.instance.ref().child(listItem[index].name.toString());
    await desertRef.delete();
    setState(() {
      listItem.removeAt(index);
      Future.delayed(const Duration(seconds: 2), () {
        _hienThiFile();
      });
    });
  }
  _xoaImgDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Scrollbar(
              child: Text('Bạn có muốn xóá bản ghi âm không?'),
            ),
            actions: <Widget>[

              ElevatedButton(
                onPressed: () {
                  _xoaAnh(index);
                  Navigator.of(context).pop();
                },
                child: const Text('Có'),
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
  String formatTime(Duration duration){
    String twoDigits (int n) => n.toString().padLeft(2, '0');
    String H = twoDigits(duration.inHours);
    String M = twoDigits(duration.inMinutes.remainder(60));
    String S = twoDigits(duration.inSeconds.remainder(60));
    return [if(duration.inHours > 0 )
      H, M, S].join(':');
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(title: Text('Ghi âm')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(duration),
                    style: const TextStyle(fontSize: 25, color: Colors.red)),
                  Text(formatTime(position),
                      style: const TextStyle(fontSize: 25, color: Colors.red)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){
                  isPlaying? audioPlayer.pause() : audioPlayer.resume();
              }, child: isPlaying? const Text('Dừng') : const Text('Nghe tiếp'),
            ),
            ElevatedButton(
                onPressed: !isRecording ? startRecording: stopRecording,
                child: !isRecording ? const Text('Bắt đầu ghi âm') : const Text('Dừng ghi âm')
            ),
            const SizedBox(
              height: 10,
            ),
            if(!isRecording && audioPath != null)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: listItem.length,
                    itemBuilder: (BuildContext context, int index){
                    return Container(
                      color: const Color(0xffF4E869),
                      margin: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                listItem[index].name.toString().substring(
                                    0, listItem[index].name.toString().length - 4),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.red),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: (){
                                    playRecording(index);
                                    isPlaying = true;
                                  },
                                  child: const Text('Nghe')
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed:(){
                                  _xoaImgDialog(context, index);
                                },
                                child: const Text('Xóa bản ghi âm'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    }
                ),
              ),
          ],
        ),
      ),
    );
  }

}