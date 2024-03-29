import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogo_bbrbet_online/features/audio_cubit/audio_cubit.dart';
import 'package:jogo_bbrbet_online/features/export.dart';
import 'package:jogo_bbrbet_online/features/game/bloc/game_bloc.dart';

import 'export.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        var audioCubit = BlocProvider.of<AudioCubit>(context);

        if (state is GameInProgressState) {
          return Stack(
            children: [
              Row(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GestureDetector(
                      onTap: () async {
                        await audioCubit.playSound1('sound/knopka.mp3');
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset(
                          "assets/images/back.png",
                          
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: MediaQuery.of(context).size.height * 0.15,
                          
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/upbloc.png'),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Text(
                                  ' Score: ',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  '${state.score}',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        await audioCubit.playSound1('sound/knopka.mp3');
                        if (context.mounted) {
                          
                        }
                        if (context.mounted) {
                          Navigator.of(context)
                              .pushReplacementNamed('/settingScreen');
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset(
                          "assets/images/settinggame.png",
                          
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        
                        
                        ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 65)),
                  Column(
                    children: [
                      Container(
                        height: 65,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/pirat.png'))),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        
                        
                        height: MediaQuery.of(context).size.height * 0.59,
                        

                        child: gameUi(state),
                      ),
                      TimerWidget(
                        level: state.level,
                      ),
                    ],
                  ),
                  
                  
                  
                  
                  
                  
                ],
              ),
            ],
          );
        }
        {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  GridView gameUi(GameInProgressState state) {
    return GridView.builder(
      
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              context.read<GameBloc>().add(InitializeDrag(draggedIndex: index));
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
              builder: (BuildContext context, List<int?> candidateData,
                  List<dynamic> rejectedData) {
                final bool isNeighbour = _isDraggedNeighbor(index, state);

                return CustomIcon(
                  iconName: getColorName(color),
                  wight: isNeighbour ? 160 : 164,
                  hight: isNeighbour ? 160 : 164,
                );
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                context
                    .read<GameBloc>()
                    .add(SwapTiles(firstIndex: data, secondIndex: index));
                context.read<GameBloc>().add(FinishDrag());
              },
            ),
          ),
        );
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
  const TimerWidget({Key? key, required this.level}) : super(key: key);
  final int level; 

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
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_minutes == 0 && _seconds == 0) {
        timer.cancel();
        Navigator.of(context).pushReplacementNamed('/winnerScreen');
      } else if (_seconds == 0) {
        _minutes--;
        _seconds = 59;
      } else {
        _seconds--;
        if (widget.level >= 5) {
          Navigator.of(context).pushReplacementNamed('/winnerScreen');
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    
    if (widget.level != oldWidget.level) {
      
      _timer.cancel();
      _minutes = 1;
      _seconds = 30;
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '  Time: ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.047,
              child: Text(
                '$_minutes:${_seconds < 10 ? '0' : ''}$_seconds',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.004,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 45),

          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '       Maps: ${widget.level}/5',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                
                height: 37, width: 40,

                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/spisok.png'),
                        scale: 1)),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
