import 'dart:async';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/screen/home/utils/direction.dart';
import 'package:snake/screen/home/utils/snake.dart';
import 'package:snake/screen/home/widgets/snake_game_controller.dart';
import 'package:snake/screen/home/widgets/snake_grid.dart';
import 'package:snake/screen/home/widgets/snake_grid_controller.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeHomePage extends StatefulWidget {
  // const
  static const int _gridSides = 15;
  static const int _milliseconds = 250;

  // constructors
  const SnakeHomePage({Key? key}) : super(key: key);

  // overrides
  @override
  State<SnakeHomePage> createState() => _SnakeHomePageState();
}

// state class
class _SnakeHomePageState extends State<SnakeHomePage> {
  // variables
  late final Random _random;
  late final SnakeGridController _gridController;
  late Snake _snake;
  late Direction _direction;
  Timer? _timer;

  // overrides
  @override
  void initState() {
    super.initState();
    _random = Random();
    _gridController = SnakeGridController();
    _snake = Snake(SnakeHomePage._gridSides);
    _direction = Direction.right;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: SnakeColors.primaryDark,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text('snake',
                  style: GoogleFonts.pressStart2p(
                    color: Colors.green,
                    fontSize: 46,
                  )),
              SnakeGrid(SnakeHomePage._gridSides, _snake, _gridController),
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
      );

  // functions
  int createNewTarget() {
    int target = _random.nextInt(15 * 15);
    return !_snake.contains(target) ? target : createNewTarget();
  }

  void start() {
    if (_timer?.isActive == true) return;
    reset();
    gameLoop(createNewTarget(), _direction);
  }

  void gameLoop(int target, Direction tempDir) {
    _gridController.showTarget?.call(target);
    _timer = Timer.periodic(
        const Duration(
          milliseconds: SnakeHomePage._milliseconds,
        ), (timer) {
      try {
        if (((tempDir == Direction.right || tempDir == Direction.left) &&
                (_direction == Direction.right ||
                    _direction == Direction.left)) ||
            ((tempDir == Direction.up || tempDir == Direction.down) &&
                (_direction == Direction.up || _direction == Direction.down))) {
          _gridController.moveSnake?.call(tempDir);
        } else {
          _gridController.moveSnake?.call(_direction);
          tempDir = _direction;
        }
      } catch (e) {
        _timer?.cancel();
      }
      if (_snake.isOn(target)) {
        _snake.eat(target);
        target = createNewTarget();
        _gridController.showTarget?.call(target);
      }
      if (_snake.eatsHimself()) _timer?.cancel();
    });
  }

  void reset() {
    _gridController.reset?.call();
    _snake.reset();
    _gridController.showSnake?.call();
    _direction = Direction.right;
  }
}
