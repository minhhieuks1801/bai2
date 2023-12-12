import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/cubit/txt_cubit.dart';
import 'package:untitled1/view/txt_view.dart';

class GhiChuTxtCubit extends StatefulWidget {
  const GhiChuTxtCubit({super.key});

  @override
  State<StatefulWidget> createState() => GhiChuTxtCubitState();
}

class GhiChuTxtCubitState extends State<GhiChuTxtCubit> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TxtCubit(),
      child: const GhiTxtView(),
    );
  }
}
