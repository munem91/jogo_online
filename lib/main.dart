import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/bloc/game_bloc.dart';

import 'features/export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/fon.png"), // Замените на путь к вашему изображению фона
                fit: BoxFit.fill,
              ),
            ),
            child: BlocProvider(
              create: (context) =>
                  GameBloc(rows: 7, columns: 6)..add(InitializeGame()),
              child: const GameScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
