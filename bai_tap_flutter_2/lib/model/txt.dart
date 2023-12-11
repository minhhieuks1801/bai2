import 'package:json_annotation/json_annotation.dart';
part 'txt.g.dart';

@JsonSerializable()
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

  factory Txt.fromJson(Map<String, dynamic> json) => $TxtFromJson(json);

  Map<String, dynamic> toJson() => $TxtToJson(this);

}