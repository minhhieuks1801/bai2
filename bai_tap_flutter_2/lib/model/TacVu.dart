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
  factory TacVu.fromJson(Map<String, dynamic> json) {
    return TacVu(
      tieuDe: json['tieuDe'],
      noiDung: json['noiDung'],
      tinhTrang: json['tinhTrang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'tinhTrang': tinhTrang
    };
  }
}