import 'package:flutter/material.dart';
import 'package:snake/screen/home/utils/brick_type.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeBrick extends StatelessWidget {
  // variables
  final SnakeBrickType type;

  // constructors
  const SnakeBrick(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 96),
            color: selectColor(),
            margin: const EdgeInsets.all(0.1),
          ),
        ),
      );

  Color selectColor() {
    switch (type) {
      case SnakeBrickType.empty:
        return SnakeColors.primaryDark;
      case SnakeBrickType.head:
        return SnakeColors.greenDark;
      case SnakeBrickType.body:
        return SnakeColors.greenLight;
      case SnakeBrickType.tail:
        return SnakeColors.green;
      case SnakeBrickType.target:
        return SnakeColors.target;
      case SnakeBrickType.eaten:
        return SnakeColors.green;
      case SnakeBrickType.dead:
        return SnakeColors.primaryLight;
      default:
        return SnakeColors.primaryDark;
    }
  }
}
