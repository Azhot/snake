import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/screen/home/widgets/snake_grid.dart';
import 'package:snake/screen/home/utils/collision_exception.dart';
import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_game_controller.dart';
import 'package:snake/shared/snake_colors.dart';
import 'package:snake/shared/strings.dart';

class SnakeHomePage extends StatefulWidget {
  // constructors
  const SnakeHomePage({Key? key}) : super(key: key);

  @override
  State<SnakeHomePage> createState() => _SnakeHomePageState();
}

class _SnakeHomePageState extends State<SnakeHomePage> {
  // configurables
  static const int _gridSideSize = 15;
  static const int _milliseconds = 192;

  // variables
  late final Random _random;
  Timer? _timer;
  late Snake _snake;
  late int _target;
  late Direction _direction;

  // getters
  int get _gridSize => _gridSideSize * _gridSideSize;

  // overrides
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _random = Random();
    _snake = Snake(_gridSideSize);
    _target = -1;
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
                Text(Strings.appName,
                    style: GoogleFonts.pressStart2p(
                      color: Colors.green,
                      fontSize: 64,
                    )),
                const SizedBox(height: 32),
                Expanded(
                    child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SnakeGrid(_gridSideSize, _snake, _target),
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
  int createNewTarget() {
    int target = _random.nextInt(_gridSize);
    return !_snake.contains(target) ? target : createNewTarget();
  }

  void start() {
    if (_timer?.isActive == true) return;
    reset();
    var prevDir = _direction;
    _timer = Timer.periodic(
        const Duration(milliseconds: _milliseconds),
        (timer) => {
              setState(() {
                try {
                  prevDir = checkedDirection(prevDir, _direction);
                  _snake.moveSnake(prevDir);
                  if (_snake.isOn(_target)) {
                    _snake.eats(_target);
                    _target = createNewTarget();
                  }
                  if (_snake.eatsHimself()) {
                    _snake.isDead = true;
                    timer.cancel();
                  }
                } on CollisionException {
                  _snake.isDead = true;
                  timer.cancel();
                }
              })
            });
  }

  Direction checkedDirection(Direction tempDir, Direction direction) =>
      (((tempDir == Direction.right || tempDir == Direction.left) &&
                  (direction == Direction.right ||
                      direction == Direction.left)) ||
              ((tempDir == Direction.up || tempDir == Direction.down) &&
                  (direction == Direction.up || direction == Direction.down)))
          ? tempDir
          : direction;

  void reset() {
    _snake = Snake(_gridSideSize);
    _target = createNewTarget();
    _direction = Direction.right;
  }
}
