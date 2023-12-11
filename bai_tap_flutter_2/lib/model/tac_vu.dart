import 'package:json_annotation/json_annotation.dart';
part 'tac_vu.g.dart';

@JsonSerializable()
class TacVu {

  final String? key;
  final String? tieuDe;
  final String? noiDung;
  final bool tinhTrang;


  TacVu({this.key, this.tieuDe, this.noiDung, required this.tinhTrang});

  TacVu copyWith({String? key, String? tieuDe, String? noiDung, required bool tinhTrang}) {
    return TacVu(
      key: key,
      tieuDe: tieuDe,
      noiDung: noiDung,
      tinhTrang: tinhTrang,
    );
  }

  factory TacVu.fromJson(Map<String, dynamic> json) => $TacVuFromJson(json);

  Map<String, dynamic> toJson() => $TacVuToJson(this);


}