import 'flatpiece.dart';
import 'settings.dart';
import 'edge.dart';
import 'fingerjointedge.dart';
import 'point.dart';
import 'blankedge.dart';
import 'lidedge.dart';

class _EdgeDetails {
  final double widthMult;
  final double heightMult;
  final bool addHeight;
  final double angle;

  const _EdgeDetails(
      this.widthMult, this.heightMult, this.addHeight, this.angle);
}

///
/// Creates a flat piece for the object that is a rectangle.
///
class RectangularPiece extends FlatPiece {
  final double height;
  final double width;

  static const List<_EdgeDetails> _kEdgeSetup = [
    _EdgeDetails(1, 0, false, 0),
    _EdgeDetails(0, 1, true, 90),
    _EdgeDetails(-1, 0, false, 180),
    _EdgeDetails(0, -1, true, 270)
  ];

  RectangularPiece(Settings setup, this.height, this.width,
      {List<EdgeType> edgeTypes})
      : super(setup) {
    // Make the edges finger joints.
    assert(edgeTypes.length == 4);
    Point cur = Point(0, 0);
    int pos = 0;
    for (EdgeType t in edgeTypes) {
      _EdgeDetails detail = _kEdgeSetup[pos];
      double mainWidth =
          (width * detail.widthMult + height * detail.heightMult).abs();
      switch (t) {
        case EdgeType.FingerJointPositive:
          edges.add(
              new FingerJointEdge(setup, cur, mainWidth, detail.angle, true));
          break;
        case EdgeType.FingerJointNegative:
          edges.add(
              new FingerJointEdge(setup, cur, mainWidth, detail.angle, false));
          break;
        case EdgeType.BlankEdge:
          edges.add(new BlankEdge(cur, mainWidth, detail.angle));
          break;
        case EdgeType.LidNegative:
          edges.add(new LidEdge(setup, cur, mainWidth, detail.angle, false));
          break;
        case EdgeType.LidPositive:
          edges.add(new LidEdge(setup, cur, mainWidth, detail.angle, true));
          break;
      }
      if (detail.addHeight) {
        cur = Point(cur.x, cur.y + height * detail.heightMult);
      } else {
        cur = Point(cur.x + width * detail.widthMult, cur.y);
      }
      pos++;
    }
  }
}
