import 'edge.dart';
import 'svgpath.dart';
import 'point.dart';

class BlankEdge with Edge {
  final double width;
  final double angle;
  final Point start;

  BlankEdge(this.start, this.width, this.angle);

  @override
  void toSvg(SvgPath path, bool first, double previous, double next) {
    if (first) {
      path.moveTo(start.add(Point(previous, 0)).transformDegree(angle));
    } else {
      path.lineTo(start);
    }
    Point end = Point(width - previous - next, 0).transformDegree(angle);
    print('$end');
    path.lineToRelative(end);
  }

  @override
  double edgeOffset(bool next) {
    return 0.0;
  }
}
