import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_online/features/bloc/game_bloc.dart';

import 'export.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameInProgressState) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 265),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                        ),
                        itemCount: state.board.length * state.board[0].length,
                        itemBuilder: (context, index) {
                          int row = index ~/ state.board[0].length;
                          int col = index % state.board[0].length;
                          int color = state.board[row][col];

                          return BlocBuilder<GameBloc, GameState>(
                            builder: (context, state) => Draggable<int>(
                              key: ValueKey<int>(index),
                              data: index,
                              childWhenDragging: CustomIcon(
                                iconName: getColorName(color),
                                wight: 64,
                                hight: 64,
                              ),
                              onDragStarted: () {
                                context
                                    .read<GameBloc>()
                                    .add(InitializeDrag(draggedIndex: index));
                              },
                              onDraggableCanceled: (velocity, offset) {
                                context.read<GameBloc>().add(FinishDrag());
                              },
                              onDragEnd: (details) {
                                context.read<GameBloc>().add(FinishDrag());
                              },
                              feedback: CustomIcon(
                                iconName: getColorName(color),
                                wight: 64,
                                hight: 64,
                              ),
                              child: DragTarget<int>(
                                key: ValueKey<int>(index),
                                builder: (BuildContext context,
                                    List<int?> candidateData,
                                    List<dynamic> rejectedData) {
                                  final bool isNeighbour =
                                      _isDraggedNeighbor(index, state);

                                  return Container(
                                    margin:
                                        EdgeInsets.all(isNeighbour ? 2.0 : 0.1),
                                    padding:
                                        EdgeInsets.all(isNeighbour ? 2.0 : 0.1),
                                    child: CustomIcon(
                                      iconName: getColorName(color),
                                      wight: isNeighbour ? 160 : 164,
                                      hight: isNeighbour ? 160 : 164,
                                    ),
                                  );
                                },
                                onWillAccept: (data) {
                                  return true;
                                },
                                onAccept: (data) {
                                  context.read<GameBloc>().add(SwapTiles(
                                      firstIndex: data, secondIndex: index));
                                  context.read<GameBloc>().add(FinishDrag());
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Positioned(
                top: 700,
                right: 130,
                child: TimerWidget(),
              ),
              Positioned(
                top: 100, // Подстройте положение при необходимости
                left: 16, // Подстройте положение при необходимости
                child: Text(
                  'Score: ${state.score}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bool _isDraggedNeighbor(int currentIndex, GameState state) {
    if (state.draggedIndex == null) {
      return false;
    }

    int draggedRow = state.draggedIndex! ~/ state.board[0].length;
    int draggedCol = state.draggedIndex! % state.board[0].length;

    int currentRow = currentIndex ~/ state.board[0].length;
    int currentCol = currentIndex % state.board[0].length;

    return (currentRow == draggedRow &&
            (currentCol == draggedCol - 1 || currentCol == draggedCol + 1) &&
            _hasMatchInRow(currentRow, state.board)) ||
        (currentCol == draggedCol &&
            (currentRow == draggedRow - 1 || currentRow == draggedRow + 1) &&
            _hasMatchInColumn(currentCol, state.board));
  }

  bool _hasMatchInRow(int row, List<List<int>> board) {
    for (int c = 0; c < board[row].length - 2; c++) {
      if (board[row][c] == board[row][c + 1] &&
          board[row][c + 1] == board[row][c + 2]) {
        return true;
      }
    }
    return false;
  }

  bool _hasMatchInColumn(int column, List<List<int>> board) {
    for (int r = 0; r < board.length - 2; r++) {
      if (board[r][column] == board[r + 1][column] &&
          board[r + 1][column] == board[r + 2][column]) {
        return true;
      }
    }
    return false;
  }

  String getColorName(int color) {
    switch (color) {
      case 0:
        return 'cherep';
      case 1:
        return 'compos';
      case 2:
        return 'bocka';
      case 3:
        return 'kruk';
      case 4:
        return 'rul';
      case 5:
        return 'trubka';
      case 6:
        return 'list';
      default:
        return 'default';
    }
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _minutes = 1;
  int _seconds = 30;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_minutes == 0 && _seconds == 0) {
        timer.cancel();
        // Здесь можно добавить логику, выполняемую по истечении времени
      } else if (_seconds == 0) {
        _minutes--;
        _seconds = 59;
      } else {
        _seconds--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Text(
        'Time: $_minutes:${_seconds < 10 ? '0' : ''}$_seconds',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
