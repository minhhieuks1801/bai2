class Txt {

  final String? key;
  final String? name;


  Txt({this.key, this.name});

  Txt copyWith({String? key, String? name}) {
    return Txt(
      key: key,
      name: name,

    );
  }

  factory Txt.fromJson(Map<String, dynamic> json) {
    return Txt(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}