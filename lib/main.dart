import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jogo_online/features/audio_cubit/audio_cubit.dart';
import 'package:jogo_online/features/game/bloc/game_bloc.dart';
import 'package:jogo_online/features/game/bloc/game_cubit.dart';

import 'features/export.dart';

void main() {
  GetIt.I.registerLazySingleton<AbstractDioRepository>(
      () => DioRepository(dio: Dio()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioCubit>(create: (context) => AudioCubit()),
        BlocProvider<GameBloc>(
            create: (context) =>
                GameBloc(rows: 7, columns: 6)..add(InitializeGame())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const FirstScreen(),
          // MenuScreen(),
          '/settingScreen': (context) => const SettingScreen(),
          '/gameScreen': (context) => const GameScreen(),
          '/winnerScreen': (context) => const WinnerScreen(),
          '/rulesScreen': (context) => const RulesScreen(),
          '/exitScreen': (context) => const ExitScreen(),
          '/menuScreen': (context) => const MenuScreen(),
          '/startScreen': (context) => const StartGame(),
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSwatch(backgroundColor: Colors.white).copyWith(
            primary: Colors.black,
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.galindo(
                color: Colors.white,
                fontSize: 32,
                shadows: [
                  const Shadow(
                      // bottomLeft
                      offset: Offset(-1.8, -1.8),
                      color: Colors.black),
                  const Shadow(
                      // bottomRight
                      offset: Offset(1.8, -1.8),
                      color: Colors.black),
                  const Shadow(
                      // topRight
                      offset: Offset(1.8, 1.8),
                      color: Colors.black),
                  const Shadow(
                      // topLeft
                      offset: Offset(-1.8, 1.8),
                      color: Colors.black),
                ]),
          ),
        ),
      ),
    );
  }
}

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
          child: CircularProgressIndicator(backgroundColor: Colors.orange),
        );
      },
      listener: (context, state) {
        if (state.status == LoadinStatus.ready &&
            (state.url == null ||
                state.url ==
                    'https://play.google.com/store/apps/details?id=tigers.fortune.plays.fun')) {
          Navigator.of(context).pushReplacementNamed('/firstScreen');
        } else if (state.status == LoadinStatus.error) {
          Navigator.of(context).pushReplacementNamed('/firstScreen');
          //
        } else if (state.status == LoadinStatus.ready) {
          debugPrint('Response from the server: ${state.url}');

          if (state.isFirstLaunch) {
            Navigator.of(context).pushReplacementNamed('/menuScreen');
          } else {
            Navigator.of(context).pushReplacementNamed('/startScreen');
          }
        }
      },
    ),
  );
}
