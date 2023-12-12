import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/cubit/img_cubit.dart';
import 'package:untitled1/view/img_view.dart';

class ListAnhApp extends StatelessWidget {
  const ListAnhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ImgCubit(),
        child: const ImgViewList(),
      ),
    );
  }
}