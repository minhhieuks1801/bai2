import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/cubit/img_cubit.dart';
import 'package:untitled1/view/img_view.dart';

class GhiHinhImgCubit extends StatefulWidget {
  const GhiHinhImgCubit({super.key});

  @override
  State<StatefulWidget> createState() => GhiChuImgCubitState();
}

class GhiChuImgCubitState extends State<GhiHinhImgCubit> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImgCubit(),
      child: const ImgViewList(),
    );
  }

}