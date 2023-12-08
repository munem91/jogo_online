import 'package:bloc/bloc.dart';
import 'package:jogo_online/features/game/game_widget.dart';

part 'screen_state.dart';

class GameCubit extends Cubit<ScreenState> {
  GameCubit(this.dioRepository)
      : super(const ScreenState(status: LoadinStatus.initial, url: null));

  Future load() async {
    emit(const ScreenState(status: LoadinStatus.loading, url: null));
    try {
      final url = await dioRepository.fetchData();
      emit(ScreenState(status: LoadinStatus.ready, url: url));
    } catch (e) {
      emit(const ScreenState(status: LoadinStatus.error, url: null));
    }
  }

  final AbstractDioRepository dioRepository;
}
