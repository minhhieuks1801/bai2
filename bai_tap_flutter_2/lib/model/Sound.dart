import 'package:untitled1/model/Img.dart';

class Sound {

  final String? key;
  final String? name;
  final String? link;
  final String? linkAnh;
  final String? tacGia;
  final String? image;
  final String? thoiGian;


  Sound({this.key, this.name, this.link, this.linkAnh, this.tacGia, this.image, this.thoiGian});

  Sound copyWith({
    String? key,
    String? name,
    String? link,
    String? linkAnh,
    String? tacGia,
    String? image,
    String? thoiGian}){
    return Sound(
        key: key,
        name: name,
        link: link,
        linkAnh: linkAnh,
        tacGia: tacGia,
        image: image,
        thoiGian: thoiGian,
    );
  }

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      key: json['name'],
      name: json['image'],
      link: json['tacGia'],
      thoiGian: json['thoiGian'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'tacGia': tacGia,
      'thoiGian': thoiGian
    };
  }
}