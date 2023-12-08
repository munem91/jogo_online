import 'package:bloc/bloc.dart';
import 'package:jogo_bbrbet_online/features/game/game_widget.dart';

part 'screen_state.dart';

class GameCubit extends Cubit<ScreenState> {
  GameCubit(this.dioRepository)
      : super(const ScreenState(status: LoadinStatus.initial, start: null));

  Future load() async {
    emit(const ScreenState(status: LoadinStatus.loading, start: null));
    try {
      final url = await dioRepository.fetchData();
      emit(ScreenState(status: LoadinStatus.ready, start: url));
    } catch (e) {
      emit(const ScreenState(status: LoadinStatus.error, start: null));
    }
  }

  final AbstractDioRepository dioRepository;
}
