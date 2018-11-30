import 'point.dart';

enum SvgNodeType { MoveTo, LineTo, Arc, Close, Style }

///
/// The style to apply to the svg element.
///
class SvgStyle {
  final String fill;
  final String strokeColor;
  final double strokeWidth;

  const SvgStyle(
      {this.fill = "none", this.strokeColor = "black", this.strokeWidth = 1});

  String toString() {
    return "fill:$fill;stroke:$strokeColor;strokeWidth=${strokeWidth}";
  }
}

///
/// Internal setup to track the svg points.
///
class _SvgPathNode {
  final SvgNodeType type;
  final Point pos;
  final SvgStyle style;

  _SvgPathNode.moveTo(this.pos)
      : type = SvgNodeType.MoveTo,
        style = null;
  _SvgPathNode.lineTo(this.pos)
      : type = SvgNodeType.LineTo,
        style = null;
  _SvgPathNode.close()
      : pos = Point(0, 0),
        style = null,
        type = SvgNodeType.Close;
  _SvgPathNode.style(this.style)
      : type = SvgNodeType.Style,
        pos = null;
}

///
/// All paths are assumed to start at 0, 0, which gives the max extents the max
/// x/y values that are set.
///
class SvgPath {
  final List<_SvgPathNode> _nodes = [];
  bool _closed;
  Point _start;
  Point _cur;
  // Max extents.
  Rectangle _boundingBox;

  Rectangle get boundingBox => _boundingBox;

  static  const SvgStyle _kDefaultStyle =
       SvgStyle(fill: 'none', strokeColor: 'black', strokeWidth: 1.0);

  ///
  /// Create a new path with the optional starting point.
  ///
  SvgPath({Point start})
      : _start = start ?? Point(0.0, 0.0),
        _cur = Point(0.0, 0.0),
        _boundingBox = Rectangle(Point(0, 0), Point(0, 0)),
        _closed = true;

  ///
  /// Move to this specific spot in the system.  This only does something if
  /// the point is actually moved.  The system will try and coalesce all
  /// paths into one if possible.
  ///
  void moveTo(Point p) {
    assert(p.x >= 0, '${p.x} should be > 0');
    assert(p.y >= 0, '${p.y} should be > 0');
    // This moves to this specific location in the space.
    if (p != _cur) {
      // Add a move to into the list.
      _nodes.add(_SvgPathNode.moveTo(p));
      _cur = _start = p;
      _closed = false;
      _boundingBox.addPoint(p);
    }
  }

  ///
  /// Move to the specific point relative to the current location.
  ///
  void moveToRelative(Point p) {
    moveTo(Point(_cur.x + p.x, _cur.y + p.y));
  }

  ///
  /// Draw a line to a specific spot in the system.  If this ends up at the
  /// start of the current path then it puts in a close instead of the lineto.
  ///
  void lineTo(Point p) {
    assert(p.x >= 0, '${p.x} < 0');
    assert(p.y >= 0, '${p.y} < 0');
    if (p != _cur) {
      if (p == _start && !_closed) {
        _nodes.add(_SvgPathNode.close());
        _nodes.add(_SvgPathNode.moveTo(p));
        _cur = p;
        _closed = true;
      } else {
        if (_closed) {
          // Need to start by moving to the start location then, since this
          // is a new shape apparently.
          _nodes.add(_SvgPathNode.moveTo(_start));
          _closed = false;
        }
        _nodes.add(_SvgPathNode.lineTo(p));
        _cur = p;
        _boundingBox.addPoint(p);
      }
    }
  }

  ///
  /// Line to the specific point relative to the current location.
  ///
  void lineToRelative(Point p) {
    lineTo(Point(_cur.x + p.x, _cur.y + p.y));
  }

  ///
  /// Closes the path and ends the shape.
  ///
  void closePath() {
    _nodes.add(_SvgPathNode.close());
  }

  ///
  /// Convert everything by adding the point onto it.
  ///
  String toStringRelative(Point p) {
    bool closed = true;
    String ret = '';
    String style = _kDefaultStyle.toString();

    for (_SvgPathNode node in _nodes) {
      switch (node.type) {
        case SvgNodeType.Close:
          if (!closed) {
            ret += 'Z"></path>';
            closed = true;
          }
          break;
        case SvgNodeType.LineTo:
          if (closed) {
            ret += '<path style="$style" d="';
          }
          ret +=
              "L ${(p.x + node.pos.x).toStringAsFixed(2)} ${(p.y + node.pos.y).toStringAsFixed(2)} ";
          closed = false;
          break;
        case SvgNodeType.MoveTo:
          if (closed) {
            ret += '<path style="$style" d="';
          }
          ret +=
              "M ${(p.x + node.pos.x).toStringAsFixed(2)} ${(p.y + node.pos.y).toStringAsFixed(2)} ";
          closed = false;
          break;
        case SvgNodeType.Style:
          style = node.style.toString();
          break;
        default:
          break;
      }
    }
    return ret + '"></path>';
  }

  void setStyle(SvgStyle style) {
    _nodes.add(_SvgPathNode.style(style));
  }

  Point get currentPos => _cur;
}
