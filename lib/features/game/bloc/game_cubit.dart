import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jogo_online/features/game/game_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fortune_tiger/features/repositories/dio_repository.dart';
// import 'package:meta/meta.dart';

part 'screen_state.dart';

class GameCubit extends Cubit<ScreenState> {
  GameCubit(this.dioRepository)
      : super(const ScreenState(
            status: LoadinStatus.initial, url: null, isFirstLaunch: true));

  Future load() async {
    emit(const ScreenState(
        status: LoadinStatus.loading, url: null, isFirstLaunch: true));

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        debugPrint('Это первый запуск!');
      } else {
        debugPrint('Это не первый запуск.');
      }

      // Сохранить факт первого запуска в Shared Preferences
      await prefs.setBool('isFirstLaunch', false);

      final url = await dioRepository.fetchData();

      emit(ScreenState(
          status: LoadinStatus.ready, url: url, isFirstLaunch: isFirstLaunch));
    } catch (e) {
      emit(const ScreenState(
          status: LoadinStatus.error, url: null, isFirstLaunch: true));
    }
  }

  final AbstractDioRepository dioRepository;
}
