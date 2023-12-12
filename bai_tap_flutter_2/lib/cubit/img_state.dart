import 'package:equatable/equatable.dart';

import 'package:untitled1/model/img.dart';

enum ImgStatus {init, start, success, error}

class ImgState extends Equatable {
  final List<Img> imgs;
  final Enum status;
  const ImgState({this.imgs = const [], this.status = ImgStatus.init});

  ImgState copyWith({List<Img>? imgs, Enum? status}) {
    return ImgState(
      imgs: imgs ?? this.imgs,
      status: status?? this.status,
    );
  }

  @override
  List<Object?> get props => [imgs, status];

}