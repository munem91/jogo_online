import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/game/bloc/game_bloc.dart';

import 'export.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fon.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: BlocProvider(
            create: (context) =>
                GameBloc(rows: 7, columns: 6)..add(InitializeGame()),
            child: const Game(),
          ),
        ),
      ),
    );
  }
}
