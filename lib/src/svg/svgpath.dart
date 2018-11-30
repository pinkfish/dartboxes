import 'package:xml/xml.dart';
import 'svgelement.dart';

/// The type of the svg path.
enum SvgPathType { MoveTo, ClosePath, LineTo }

///
/// A piece to use in the svg file.
///
class SvgPathPiece {
  final SvgPathType type;
  final double x;
  final double y;
  final bool relative;

  SvgPathPiece.moveTo(this.x, this.y)
      : relative = false,
        type = SvgPathType.MoveTo;
  SvgPathPiece.moveToRelative(this.x, this.y)
      : relative = true,
        type = SvgPathType.MoveTo;
  SvgPathPiece.lineTo(this.x, this.y)
      : relative = false,
        type = SvgPathType.LineTo;
  SvgPathPiece.lineToRelative(this.x, this.y)
      : relative = true,
        type = SvgPathType.LineTo;
  SvgPathPiece.close()
      : x = 0.0,
        y = 0.0,
        relative = false,
        type = SvgPathType.LineTo;

  String toString() {
    String ret;
    switch (type) {
      case SvgPathType.MoveTo:
        ret = "m $x,$y";
        break;
      case SvgPathType.LineTo:
        if (x == 0) {
          ret = "v $y";
        } else if (y == 0) {
          ret = "h $x";
        } else {
          ret = "l $x,$y";
        }
        break;
      case SvgPathType.ClosePath:
        ret = "z";
        break;
    }
    if (!relative) {
      return ret.toUpperCase();
    }
    return ret;
  }
}

///
/// Makes the svg path, which is a sequence of nodes/arcs.
///
class SvgPath extends SvgElement {
  final List<SvgPathPiece> pieces = [];

  @override
  void renderToInner(XmlBuilder builder) {
    builder.element("path", nest: () {
      String res = pieces.map((SvgPathPiece p) => p.toString()).join(" ");
      builder.attribute("d", res);
    });
  }
}
