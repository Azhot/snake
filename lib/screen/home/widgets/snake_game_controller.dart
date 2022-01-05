import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/shared/snake_colors.dart';

class SnakeGameController extends StatelessWidget {
  // variables
  final Function() start;
  final Function() goRight;
  final Function() goLeft;
  final Function() goUp;
  final Function() goDown;

  // constructors
  const SnakeGameController(
      {required this.start,
      required this.goRight,
      required this.goLeft,
      required this.goUp,
      required this.goDown,
      Key? key})
      : super(key: key);

  // overrides
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [button(goUp, Icons.keyboard_arrow_up)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              button(goLeft, Icons.keyboard_arrow_left),
              Padding(
                padding: const EdgeInsets.all(8),
                child: button(start, Icons.play_arrow),
              ),
              button(goRight, Icons.keyboard_arrow_right)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [button(goDown, Icons.keyboard_arrow_down)],
          ),
        ],
      );

  Widget button(void Function() onTap, IconData iconData) => InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: SnakeColors.primaryLight,
        highlightColor: SnakeColors.primaryLight,
        onTap: () {
          onTap();
          HapticFeedback.selectionClick();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: SnakeColors.primaryLight),
              borderRadius: BorderRadius.circular(18)),
          child: Icon(iconData, color: Colors.green, size: 64),
        ),
      );
}
