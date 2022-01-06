import 'package:snake/screen/home/utils/collision_exception.dart';
import 'package:snake/screen/home/utils/direction.dart';

class Snake {
  // variables
  final List<int> _positionsOnGrid;
  final List<int> _eatenTargets = [];
  final int _gridSidesLength;

  // constructors
  Snake(this._gridSidesLength)
      : _positionsOnGrid = [_startingPoint(_gridSidesLength)];

  // getters
  int get head => _positionsOnGrid.first;
  int get tail => _positionsOnGrid.last;
  int get size => _positionsOnGrid.length;

  // static functions
  static int _startingPoint(final int gridSidesLength) =>
      ((gridSidesLength + 1 - gridSidesLength % 2) * gridSidesLength / 2 - 1)
          .ceil();

  // functions
  void moveSnake(final Direction direction) {
    moveBody();
    if (_eatenTargets.isNotEmpty && _eatenTargets.first == tail) {
      _positionsOnGrid.add(_eatenTargets.removeAt(0));
    }
    _positionsOnGrid[0] = moveHead(direction);
    if (eatsHimself()) throw CollisionException();
  }

  int moveHead(final Direction direction) {
    switch (direction) {
      case Direction.right:
        if ((head + 1) % _gridSidesLength == 0) {
          throw CollisionException();
        }
        return _positionsOnGrid[0] + 1;
      case Direction.left:
        if (head % _gridSidesLength == 0) {
          throw CollisionException();
        }
        return _positionsOnGrid[0] - 1;
      case Direction.up:
        if (head - _gridSidesLength < 0) {
          throw CollisionException();
        }
        return head - _gridSidesLength;
      case Direction.down:
        if (head + _gridSidesLength >= _gridSidesLength * _gridSidesLength) {
          throw CollisionException();
        }
        return head + _gridSidesLength;
      default:
        throw Exception('$direction is not implemented');
    }
  }

  void moveBody() {
    for (int i = size - 1; i > 0; i--) {
      _positionsOnGrid[i] = _positionsOnGrid[i - 1];
    }
  }

  int positionAt(int index) => _positionsOnGrid[index];

  bool contains(final int target) => _positionsOnGrid.contains(target);

  bool digests(final int target) => _eatenTargets.contains(target);

  bool isOn(final int target) => head == target;

  void eats(final int target) => _eatenTargets.add(target);

  bool eatsHimself() => _positionsOnGrid.getRange(1, size).contains(head);

  void reset() {
    _positionsOnGrid.clear();
    _eatenTargets.clear();
    _positionsOnGrid.add(_startingPoint(_gridSidesLength));
  }
}
