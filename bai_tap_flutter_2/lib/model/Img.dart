class Img {

  String? key;
  String? name;
  String? link;


  Img(this.key, this.name, this.link);

  Map<String, dynamic> toJson() {
    return {
    'name': name,
    };
  }
}