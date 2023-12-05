class Text {

  String? key;
  String? name;


  Text(this.key, this.name);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}