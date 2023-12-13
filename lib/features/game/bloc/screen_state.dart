
part of 'game_cubit.dart';

class ScreenState {
  final LoadinStatus status;
  final String? start;

  const ScreenState({
    required this.status,
    this.start,
  });
}

enum LoadinStatus { initial, loading, ready, error }
