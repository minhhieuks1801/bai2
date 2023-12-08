class TacVu {

  String? key;
  String? tieuDe;
  String? noiDung;
  bool tinhTrang;


  TacVu(this.key, this.tieuDe, this.noiDung, this.tinhTrang);

  Map<String, dynamic> toJson() {
    return {
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'tinhTrang': tinhTrang
    };
  }
}