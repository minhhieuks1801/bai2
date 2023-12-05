class Sound {

  String? key;
  String? name;
  String? link;

  Sound(this.key, this.name, this.link);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}