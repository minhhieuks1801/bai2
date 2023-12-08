class Txt {

  String? key;
  String? name;


  Txt(this.key, this.name);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}