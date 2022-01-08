import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/screen/home/utils/direction_controller.dart';
import 'package:snake/screen/home/widgets/snake_grid.dart';
import 'package:snake/screen/home/utils/collision_exception.dart';
import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_joystick.dart';
import 'package:snake/shared/snake_colors.dart';
import 'package:snake/shared/strings.dart';

class SnakeGamePage extends StatefulWidget {
  // constructors
  const SnakeGamePage({Key? key}) : super(key: key);

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  // configurables
  static const int _gridSideSize = 15;
  static const int _milliseconds = 192;

  // variables
  late Timer? _timer;
  late Snake _snake;
  late int _target;
  late DirectionController _dirController;

  // getters
  int get _gridSize => _gridSideSize * _gridSideSize;

  // overrides
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _timer = null;
    _snake = Snake(_gridSideSize);
    _target = -1;
    _dirController = DirectionController(start: Direction.right);
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
                SnakeJoystick(
                  start: start,
                  goRight: () => _dirController.direction = Direction.right,
                  goLeft: () => _dirController.direction = Direction.left,
                  goUp: () => _dirController.direction = Direction.up,
                  goDown: () => _dirController.direction = Direction.down,
                ),
              ],
            ),
          ),
        ),
      );

  // functions
  int newTarget() {
    int target = Random().nextInt(_gridSize);
    return !_snake.contains(target) ? target : newTarget();
  }

  void start() {
    if (_timer?.isActive == true) return;
    reset();
    _timer = Timer.periodic(
        const Duration(milliseconds: _milliseconds),
        (timer) => {
              setState(() {
                try {
                  _snake.moveSnake(_dirController.direction);
                  if (_snake.isOn(_target)) {
                    _snake.eats(_target);
                    _target = newTarget();
                  }
                  if (_snake.eatsHimself()) throw CollisionException();
                } on CollisionException {
                  _snake.dies();
                  timer.cancel();
                }
              })
            });
  }

  void reset() {
    _snake = Snake(_gridSideSize);
    _target = newTarget();
  }
}
