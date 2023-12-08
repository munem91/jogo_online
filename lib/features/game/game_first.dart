


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jogo_online/features/game/bloc/game_cubit.dart';

import '../export.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(
      create: (context) =>
          GameCubit(GetIt.I.get<AbstractDioRepository>())..load(),
      child: Scaffold(
        body: content(context),
      ),
    );
  }
}

Widget content(BuildContext context) {
  return Center(
    child: BlocConsumer<GameCubit, ScreenState>(
      builder: (context, state) {
        return const Center(
          child: LoadingScreen(),
        );
      },
      listener: (context, state) {
        if (state.status == LoadinStatus.ready && (state.url == null)) {
          Navigator.of(context).pushReplacementNamed('/menuScreen');
        } else if (state.status == LoadinStatus.error) {
          Navigator.of(context).pushReplacementNamed('/menuScreen');
        } else if (state.status == LoadinStatus.ready) {
          Navigator.of(context).pushReplacementNamed('/startScreen');
        } else {
          Navigator.of(context).pushReplacementNamed('/menuScreen');
        }
      },
    ),
  );
}
