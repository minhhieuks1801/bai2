
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart' show PlayerState;




import 'model/sound.dart';

class GhiChuSound extends StatefulWidget{
  const GhiChuSound({super.key});
  @override
  GhiChuSoundState createState() => GhiChuSoundState();
}

class GhiChuSoundState extends State<GhiChuSound> with TickerProviderStateMixin {
  int? a = 0, b = 0, c;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String? audioPath = '';
  List<Sound> listItem = [], listItem1 = [];
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String link = '';
  bool moNhac = false;
  Duration? k;

  @override
  void initState() {
    hienThiFile();
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
    audioPlayer.onPlayerComplete.listen((event) {
      if (c! < listItem.length - 1) {
        playRecording(c! + 1);
        setState(() {
          link = listItem[c! + 1].linkAnh.toString();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(title: const Text('Ghi âm')),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff1f005c),
                Color(0xff5b0060),
                Color(0xff870160),
                Color(0xffac255e),
                Color(0xffca485c),
                Color(0xffe16b5c),
                Color(0xfff39060),
                Color(0xffffb56b),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              moNhac?
                Column(
                  children: [
                    RotationTransition(
                      turns: _animation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Image.network(
                            fit: BoxFit.fill,
                            link,
                            height: 300,
                            width: 300,

                          ),
                        ),
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatTime(position),
                              style: const TextStyle(fontSize: 20, color: Colors.white)),
                          Text('/${formatTime(duration)}',
                              style: const TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: (){
                            if(c! > 0) {
                              playRecording(c! - 1);
                              int d = c! - 1;
                              link = listItem[d].linkAnh.toString();
                              setState(() {
                              });
                            }
                          },
                          iconSize: 72,
                          icon: const Icon(
                              Icons.arrow_left
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            isPlaying? audioPlayer.pause() : audioPlayer.resume();
                          },
                            iconSize: 72,
                          icon: isPlaying? const Icon(
                              Icons.play_circle
                          ) : const Icon(
                              Icons.pause
                          )
                        ),
                        IconButton(
                          onPressed: (){
                            if(c! < listItem.length-1) {
                              playRecording(c! + 1);
                              setState(() {
                                link = listItem[c! + 1].linkAnh.toString();
                              });

                            }
                          },
                          iconSize: 72,
                          icon: const Icon(
                              Icons.arrow_right
                          ),
                        ),
                      ],
                    ),
                  ],
                ) :
                const SizedBox(
                  height: 30,
                ),
              IconButton(
                  iconSize: 72,
                  color: !isRecording? Colors.white: Colors.red,
                  onPressed: !isRecording ? startRecording: stopRecording,
                  icon: !isRecording ? const Icon(Icons.mic) : const Icon(Icons.radio_button_checked)
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
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.only(left: 15, top: 4, right: 0, bottom: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xffF4E869),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.5,
                                    child: Text(listItem[index].name.toString().substring(
                                        0, listItem[index].name.toString().length - 4),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20, color: Colors.black)
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: (){
                                        playRecording(index);
                                        link = listItem[index].linkAnh.toString();
                                        isPlaying = true;
                                        moNhac = true;
                                        setState(() {
                                          k = const Duration(seconds: 500);
                                        });
                                      },
                                    icon: const Icon(
                                        Icons.play_circle
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      XemThongTinSoundDialog(context, index);
                                    },
                                    icon: const Icon(
                                        Icons.visibility
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:(){
                                      xoaSoundDialog(context, index);
                                    },
                                    icon: const Icon(
                                        Icons.delete
                                    ),
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
      ),
    );
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
    setState(() {
      k = const Duration(seconds: 3000);
      c = index;
      isPlaying = true;
    });
  }
  Future<void> pauseRecording() async {
    audioPlayer.pause();
    setState(() {});
  }
  Future<void> uploadFile() async {
    File file = File(audioPath!);
    String name = DateTime.now().toString().split('.')[0];
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('$name.M4A');
      Sound i = Sound(key: '', name: '$name.M4A', link: '', linkAnh: '', tacGia: 'Nguyễn Minh Hiệu', image: 'khỉ đá 2.PNG', thoiGian: name);
      DatabaseReference postListRef = FirebaseDatabase.instance.reference();
      postListRef.child('Sound').push().set(i.toJson());
      // Tải lên là tệp M4a
      await storageReference.putFile(
        file,
        SettableMetadata(contentType: 'audio/m4a'),
      );
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
  Future<void> hienThiFile() async {
    try {
      Query refAnh = FirebaseDatabase.instance.ref('Sound').orderByChild('name');
      refAnh.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        listItem1.clear();
        listItem.clear();
        values.forEach((key, item) {
          setState(() {
            listItem1.add(Sound(key: key, name: item['name'].toString(), link: '', linkAnh: '', tacGia: item['tacGia'].toString(), image: item['image'].toString(), thoiGian: item['thoiGian'].toString()));
            layFileFireBase(item['name'].toString(), item['image'].toString());
          });
        });
      }, onError: (error) {
      });
    } catch(e){
    }
  }
  Future<void> layFileFireBase(String tenfile, String tenAnh) async{
    Reference ref = FirebaseStorage.instance.ref().child(tenfile);
    String url = await ref.getDownloadURL();
    Reference refAnh = FirebaseStorage.instance.ref().child(tenAnh);
    String urlAnh = await refAnh.getDownloadURL();
      setState(() {
        listItem1.where((s) => s.name == tenfile).forEach((s) {
          listItem.add(s.copyWith(link: url, linkAnh: urlAnh, key: s.key, name: s.name, thoiGian: s.thoiGian, image: s.image, tacGia: s.tacGia));
      });
    });
  }

  Future<void> xoaAnh(int index) async {
    DatabaseReference deleteFB = FirebaseDatabase.instance.reference().child('Sound/${listItem[index].key}');
    deleteFB.remove();

    final desertRef = FirebaseStorage.instance.ref().child(listItem[index].name.toString());
    await desertRef.delete();
    setState(() {
      listItem.removeAt(index);
      Future.delayed(const Duration(seconds: 2), () {
        hienThiFile();
      });
    });
  }
  xoaSoundDialog(BuildContext context, int index) async {
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
                  xoaAnh(index);
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

  XemThongTinSoundDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Scrollbar(
              child: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Text('Tác giả: ${listItem[index].tacGia}' ),
                    Text('Thời gian: ${listItem[index].thoiGian}'),
                    Text('Tên: ${listItem[index].name}'),
                    SizedBox(
                      height: 200,
                      child: Image.network(
                        listItem[index].linkAnh.toString(),
                        fit: BoxFit.fill,
                        height: 300,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
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

  String formatTime(Duration duration){
    String twoDigits (int n) => n.toString().padLeft(2, '0');
    String H = twoDigits(duration.inHours);
    String M = twoDigits(duration.inMinutes.remainder(60));
    String S = twoDigits(duration.inSeconds.remainder(60));
    return [if(duration.inHours > 0 )
      H, M, S].join(':');

  }


  late final AnimationController _controller = AnimationController(
    duration: k,
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );


}