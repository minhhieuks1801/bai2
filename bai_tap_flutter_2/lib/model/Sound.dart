class Sound {

  String? key;
  String? name;
  String? link;
  String? linkAnh;
  String? tacGia;
  String? image;
  String? thoiGian;


  Sound(this.key, this.name, this.link, this.linkAnh, this.tacGia, this.image, this.thoiGian);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'tacGia': tacGia,
      'thoiGian': thoiGian
    };
  }
}