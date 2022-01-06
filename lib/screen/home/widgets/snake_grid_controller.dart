import 'package:snake/screen/home/utils/direction.dart';

class SnakeGridController {
  // variables
  void Function(Direction direction)? moveSnake;
  void Function()? reset;
}
