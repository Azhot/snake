import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/screen/home/utils/collision_exception.dart';
import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/widgets/snake_game_controller.dart';
import 'package:snake/screen/home/widgets/snake_grid.dart';
import 'package:snake/screen/home/widgets/snake_grid_controller.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeHomePage extends StatefulWidget {
  // const
  static const int _gridSides = 13;
  static const int _milliseconds = 200;

  // constructors
  const SnakeHomePage({Key? key}) : super(key: key);

  // overrides
  @override
  State<SnakeHomePage> createState() => _SnakeHomePageState();
}

// state class
class _SnakeHomePageState extends State<SnakeHomePage> {
  // variables
  late final SnakeGridController _gridController;
  late Direction _direction;
  Timer? _timer;

  // overrides
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _gridController = SnakeGridController();
    _direction = Direction.right;
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([...DeviceOrientation.values]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: SnakeColors.primaryDark,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('snake',
                    style: GoogleFonts.pressStart2p(
                      color: Colors.green,
                      fontSize: 46,
                    )),
                const SizedBox(height: 32),
                Expanded(
                    child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SnakeGrid(SnakeHomePage._gridSides, _gridController),
                  ),
                )),
                const SizedBox(height: 16),
                SnakeGameController(
                  start: start,
                  goRight: () => _direction = Direction.right,
                  goLeft: () => _direction = Direction.left,
                  goUp: () => _direction = Direction.up,
                  goDown: () => _direction = Direction.down,
                ),
              ],
            ),
          ),
        ),
      );

  // functions
  void start() {
    if (_timer?.isActive == true) return;
    reset();
    gameLoop();
  }

  void gameLoop() {
    var tempDir = _direction;
    _timer = Timer.periodic(
        const Duration(milliseconds: SnakeHomePage._milliseconds), (timer) {
      // todo: use provider to provide direction ?
      try {
        switch (tempDir) {
          case Direction.right:
          case Direction.left:
            if (_direction != Direction.right && _direction != Direction.left) {
              tempDir = _direction;
            }
            break;
          case Direction.up:
          case Direction.down:
            if (_direction != Direction.up && _direction != Direction.down) {
              tempDir = _direction;
            }
            break;
        }
        _gridController.moveSnake?.call(tempDir);
      } on CollisionException {
        timer.cancel();
      }
    });
  }

  void reset() {
    _gridController.reset?.call();
    _direction = Direction.right;
  }
}
