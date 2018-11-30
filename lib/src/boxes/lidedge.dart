import 'edge.dart';
import 'svgpath.dart';
import 'point.dart';
import 'settings.dart';

class LidEdge with Edge {
  /// The setup for this specific box.
  final Settings setup;

  final double width;
  final double angle;
  final Point start;
  final bool positive;

  LidEdge(this.setup, this.start, this.width, this.angle, this.positive);

  @override
  void toSvg(SvgPath path, bool first, double previous, double next) {
    // Goes in the middle.
    double middle = width / 2;

    // Tab size.
    double tabSize = width * setup.lidSettings.tabSize;
    if (tabSize < setup.lidSettings.minSize) {
      tabSize = setup.lidSettings.minSize;
    }

    double mult = 1.0;
    if (first) {
      if (positive) {
        path.moveTo(start.add(Point(previous, 0).transformDegree(angle)));
      } else {
        path.moveTo(start
            .add(Point(previous, setup.boardWidth).transformDegree(angle)));
        mult = -1.0;
      }
    } else {
      // We do a lineto instead.
      if (positive) {
        path.lineTo(start.add(Point(previous, 0).transformDegree(angle)));
      } else {
        path.lineTo(start
            .add(Point(previous, setup.boardWidth).transformDegree(angle)));
        mult = -1.0;
      }
    }

    // One single finger, basically.
    double positiveSize = (width - tabSize) / 2;
    double burnCorrection = setup.burnCorrection / 2;
    if (positive) {
      burnCorrection = -burnCorrection;
    }
    path.lineToRelative(Point(positiveSize - previous - burnCorrection, 0).transformDegree(angle));
    path.lineToRelative(
        Point(0, setup.boardWidth * mult).transformDegree(angle));
    path.lineToRelative(Point(tabSize + burnCorrection * 2, 0).transformDegree(angle));
    path.lineToRelative(
        Point(0, -setup.boardWidth * mult).transformDegree(angle));

    // Go from where we are to the edge of the board.
    if (positive) {
      path.lineTo(start.add(
          Point(width - setup.boardWidth - next, 0).transformDegree(angle)));
    } else {
       path.lineTo(start.add(
          Point(width - setup.boardWidth - next, setup.boardWidth)
              .transformDegree(angle)));
    }
  }

  @override
  double edgeOffset(bool next) {
    if (positive) {
      return 0.0;
    }
    return setup.boardWidth;
  }
}
