import 'settings.dart';
import 'edge.dart';
import 'svgpath.dart';
import 'point.dart';
import 'flatpiecedecorator.dart';
import 'flatpiece.dart';
import 'svgresult.dart';

///
/// Definition of a specific finger in the joint.
///
class Finger {
  /// The start position of the finger.
  final double startOffset;

  /// The postive size of the finger
  final double positiveSize;

  /// The negative size of the finger
  final double negativeSize;

  /// If this finger has a negative space.
  bool hasNegative;

  Finger(
      this.startOffset, this.hasNegative, this.positiveSize, this.negativeSize);
}

///
/// Callbacks for making the actual fingers.
///
typedef FingerLayout = int Function(double size);

///
/// Creates an edge with a finger joint.
///
class FingerDetails {
  // Angle which the finger joints run at.
  final double angle;

  /// Where the finger joint starts
  final Point start;

  /// The width of the finger joint
  final double width;

  /// The setup for this specific box.
  final Settings setup;

  // If this is a positive or negative edge/set.
  final bool positive;

  int _numFingers;

  // Width of each part of the finger, each '1.0' of size.
  double _fingerSectionWidth;

  ///
  /// Setup the finger joint with the start position and the width/angle
  /// of the joint.
  ///
  FingerDetails(this.setup, this.start, this.width, this.angle, this.positive) {
    // Work out the number of fingers.
    double extraOffset = setup.boardWidth * setup.extraSpace;
    double middle = width - extraOffset * 2.0;
    // Add in space at the end to match up for the fact the spacing is uneven.
    middle += setup.fingerSettings.negativeFinger * setup.boardWidth;
    double fingerSpaceSize = setup.boardWidth *
        (setup.fingerSettings.positiveFinger +
            setup.fingerSettings.negativeFinger);
    // Make sure the number is even.
    _numFingers = (middle ~/ fingerSpaceSize) ~/ 2 * 2;

    // Work out the width of each finger.
    double total = _numFingers.toDouble() *
            (setup.fingerSettings.positiveFinger +
                setup.fingerSettings.negativeFinger) -
        setup.fingerSettings.negativeFinger +
        setup.extraSpace * 2.0;
    _fingerSectionWidth = width / total;
  }

  ///
  /// Number of fingers for the specified width.
  ///
  int get numFingers => _numFingers;

  /// Size of the basic finger.
  double get sizeOfBasic => _fingerSectionWidth;

  ///
  /// The size of the specified finger.  For standard edges this is always
  /// the same.
  ///
  Finger fingerDetail(int pos) {
    double basic = sizeOfBasic;

    if (pos == 0) {
      return new Finger(
          0.0,
          true,
          basic * setup.fingerSettings.positiveFinger +
              setup.extraSpace * basic,
          basic * setup.fingerSettings.negativeFinger);
    }

    // How many steps to this position in the finger joint.
    double numSteps = setup.extraSpace +
        pos *
            (setup.fingerSettings.positiveFinger +
                setup.fingerSettings.negativeFinger);
    if (pos == numFingers - 1) {
      return new Finger(
          numSteps * basic + setup.extraSpace * basic,
          false,
          setup.fingerSettings.positiveFinger * basic +
              setup.extraSpace * basic,
          0.0);
    }
    return new Finger(
        numSteps * basic + setup.extraSpace * basic,
        true,
        setup.fingerSettings.positiveFinger * basic,
        setup.fingerSettings.negativeFinger * basic);
  }

  void makeFingers(double previous, double next, FingerLayout positiveLayout,
      FingerLayout negativeLayout) {
    print('Finger joint toSvg $angle $_numFingers $width $sizeOfBasic');
    double mult = 1.0;

    if (positive) {
      mult = 1.0;
    } else {
      mult = -1.0;
    }

    double burnCorrection = setup.burnCorrection;
    if (positive) {
      burnCorrection = -burnCorrection;
    }

    for (int i = 0; i < _numFingers; i++) {
      Finger f = fingerDetail(i);

      double positiveSize = f.positiveSize;
      if (i == 0) {
        positiveSize -= previous;
      } else if (i == _numFingers - 1) {
        positiveSize -= next;
      } else {
        positiveSize -= burnCorrection;
      }
      positiveLayout(positiveSize - burnCorrection);
      if (f.hasNegative) {
        negativeLayout(f.negativeSize + burnCorrection * 2);
      } else {
        //print('no negative $i');
      }
    }
  }
}

///
/// Creates a series of holes in the side to match the finger joint.
///
class FingerJointHoles extends FingerDetails with FlatPieceDecorator {
  final double distanceFromEdge;

  FingerJointHoles(Settings settings, Point start, double width, double angle,
      this.distanceFromEdge, bool positive)
      : super(settings, start, width, angle, positive);

  @override
  void decorate(FlatPiece piece, SvgSection section) {
    // Start from a board width inside.
    double curPos = setup.boardWidth;
    makeFingers(setup.boardWidth, setup.boardWidth, (double positiveSize) {
      if (positive) {
        // Make a box.
        SvgPath path = new SvgPath();
        path.setStyle(SvgStyle(strokeColor: 'green'));
        path.moveTo(Point(curPos, distanceFromEdge).transformDegree(angle));
        path.moveTo(Point(curPos + positiveSize, distanceFromEdge)
            .transformDegree(angle));
        path.moveTo(Point(curPos + positiveSize,
                distanceFromEdge + setup.boardWidth - setup.burnCorrection)
            .transformDegree(angle));
        path.moveTo(Point(curPos,
            distanceFromEdge + setup.boardWidth - setup.burnCorrection)
            .transformDegree(angle));
        path.closePath();
        section.addPath(path);
      }
      curPos += positiveSize;
    }, (double negativeSize) {
      if (!positive) {
        // Make a box.
        SvgPath path = new SvgPath();
        path.setStyle(SvgStyle(strokeColor: 'green'));
        path.moveTo(Point(curPos, distanceFromEdge).transformDegree(angle));
        path.moveTo(Point(curPos + negativeSize, distanceFromEdge)
            .transformDegree(angle));
        path.moveTo(Point(curPos + negativeSize,
            distanceFromEdge + setup.boardWidth - setup.burnCorrection)
            .transformDegree(angle));
        path.moveTo(Point(curPos,
            distanceFromEdge + setup.boardWidth - setup.burnCorrection)
            .transformDegree(angle));
        path.closePath();
        section.addPath(path);

      }
      curPos += negativeSize;
    });
  }
}

///
/// Creates an edge with a finger joint.
///
class FingerJointEdge extends FingerDetails with Edge {
  ///
  /// Create a finger joint edge for this box.
  ///
  FingerJointEdge(
      Settings settings, Point start, double width, double angle, bool positive)
      : super(settings, start, width, angle, positive);

  @override
  double edgeOffset(bool next) {
    if (positive) {
      return 0.0;
    }
    return setup.boardWidth;
  }

  @override
  void toSvg(SvgPath path, bool first, double previous, double next) {
    print('Finger joint toSvg $angle $_numFingers $width $sizeOfBasic');
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

    makeFingers(previous, next, (double positiveSize) {
      print(
          '${path.currentPos} move to ${Point(positiveSize, 0).transformDegree(angle)}');
      path.lineToRelative(Point(positiveSize, 0).transformDegree(angle));
    }, (double negativeSize) {
      path.lineToRelative(
          Point(0, setup.boardWidth * mult).transformDegree(angle));
      path.lineToRelative(Point(negativeSize, 0).transformDegree(angle));
      path.lineToRelative(
          Point(0, -setup.boardWidth * mult).transformDegree(angle));
    });

    // Go from where we are to the edge of the board.
    if (positive) {
      path.lineTo(start.add(
          Point(width - setup.boardWidth - next, 0).transformDegree(angle)));
    } else {
      //print(
      //    'Waffles $start, ${width - setup.boardWidth} ${setup.boardWidth * mult} $angle');
      path.lineTo(start.add(
          Point(width - setup.boardWidth - next, setup.boardWidth)
              .transformDegree(angle)));
    }
  }
}
