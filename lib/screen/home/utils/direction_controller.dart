import 'package:snake/screen/home/utils/direction.dart';

class DirectionController {
  // variables
  Direction _current;
  Direction _next;
  Direction _buffer;

  // constructors
  DirectionController({required Direction start})
      : _next = start,
        _current = start,
        _buffer = start;

  // getters
  Direction get direction {
    if (_current != _buffer) {
      _current = _buffer;
      _buffer = _next;
    } else {
      _current = _next;
      _buffer = _current;
    }
    return _current;
  }

  // setters
  set direction(final Direction direction) => {
        _buffer = _checkDirection(_current, _next),
        _next = _checkDirection(_buffer, direction)
      };

  // functions
  /// Returns [old] direction if [next] direction is on the same axis.
  Direction _checkDirection(final Direction old, final Direction next) =>
      (((old == Direction.right || old == Direction.left) &&
                  (next == Direction.right || next == Direction.left)) ||
              ((old == Direction.up || old == Direction.down) &&
                  (next == Direction.up || next == Direction.down)))
          ? old
          : next;
}
