class Img {

  String? key;
  String? name;
  int? type;
  String? link;


  Img(this.key, this.name, this.type, this.link);

  Map<String, dynamic> toJson() {
    return {
    'name': name,
    'type': type,
    };
  }
}