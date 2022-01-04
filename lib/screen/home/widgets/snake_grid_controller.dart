import 'package:snake/screen/home/utils/direction.dart';

class SnakeGridController {
  // variables
  void Function()? showSnake;
  void Function(Direction direction)? moveSnake;
  void Function(int index)? showTarget;
  void Function()? reset;
}
