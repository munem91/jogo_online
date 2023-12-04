import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/game/bloc/game_bloc.dart';

class WinnerScreen extends StatelessWidget {
  const WinnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      
        return Scaffold(
          body: Center(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/win.png"), // Замените на путь к вашему изображению фона
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score: $state.finalScore',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // Добавьте другие элементы интерфейса по мере необходимости
                ],
              ),
            ),
          ),
        );
    
    });
  }
}
