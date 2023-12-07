import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jogo_online/features/game/game_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fortune_tiger/features/repositories/dio_repository.dart';
// import 'package:meta/meta.dart';

part 'screen_state.dart';

class GameCubit extends Cubit<ScreenState> {
  GameCubit(this.dioRepository)
      : super(const ScreenState(status: LoadinStatus.initial, url: null));

  Future load() async {
    emit(const ScreenState(status: LoadinStatus.loading, url: null));

    try {
      final String? data =
          await dioRepository.fetchData(); // Уточните тип данных здесь

      if (data != null) {
        const url = 'fefe'; // Уточните тип данных здесь

        if (url != null) {
          emit(const ScreenState(status: LoadinStatus.ready, url: url));
          print(url);
        } else {
          emit(const ScreenState(status: LoadinStatus.error, url: null));
        }
      } else {
        emit(const ScreenState(status: LoadinStatus.error, url: null));
      }
    } catch (e) {
      emit(const ScreenState(status: LoadinStatus.error, url: null));
    }
  }

  final AbstractDioRepository dioRepository;
}

bool isRedirect(Uri uri) {
  return uri.host != 'example.com';
}
