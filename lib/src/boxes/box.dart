import 'dart:svg';
import 'dart:math';
import 'flatpiece.dart';
import 'svgresult.dart';
import 'rectangularpiece.dart';
import 'settings.dart';
import 'edge.dart';

enum SideType {
  Open,
  Fingers,
  Lid,
}

///
/// Create a nice little bbox.
class Box {
  List<FlatPiece> _sides = [];
  double x;
  double y;
  double z;
  List<SideType> _sideTypes;

  ///
  /// Setup the box. sides are top, front, side, back, side, bottom
  ///
  Box(Settings setup, this.x, this.y, this.z, this._sideTypes) {
    assert(_sideTypes.length == 6);
    for (int i = 0; i < _sideTypes.length; i++) {
      SideType type = _sideTypes[i];
      switch (type) {
        case SideType.Open:
          // Nothing to do for an open  side.
          break;
        case SideType.Fingers:
        case SideType.Lid:
          // The way each side is setup depends on the surrounding sides.
          List<SideType> n = neighbours(i);
          List<EdgeType> edges = [];
          int j = 0;
          for (SideType thisSide in n) {
            switch (thisSide) {
              case SideType.Open:
                edges.add(EdgeType.BlankEdge);
                break;
              case SideType.Fingers:
                if (i == 0 || i == 5) {
                  edges.add(type == SideType.Fingers
                      ? EdgeType.FingerJointPositive
                      : EdgeType.LidNegative);
                } else {
                  if ((i + j) % 2 == 1 || j == 0 || j == 2) {
                    edges.add(type == SideType.Fingers
                        ? EdgeType.FingerJointNegative
                        : EdgeType.LidPositive);
                  } else {
                    edges.add(type == SideType.Fingers
                        ? EdgeType.FingerJointPositive
                        : EdgeType.LidNegative);
                  }
                }
                break;
              case SideType.Lid:
                if (i == 0 || i == 5) {
                  edges.add(EdgeType.LidNegative);
                } else {
                  if ((i + j) % 2 == 1 || j == 0 || j == 2) {
                    edges.add(EdgeType.LidPositive);
                  } else {
                    edges.add(EdgeType.LidNegative);
                  }
                }
                break;
            }
            j++;
          }
          _sides.add(RectangularPiece(setup, widthFor(i), heightFor(i),
              edgeTypes: edges));
          break;
      }
    }
  }

  List<SideType> neighbours(int side) {
    switch (side) {
      case 0:
      case 5:
        return [_sideTypes[1], _sideTypes[2], _sideTypes[3], _sideTypes[4]];
      case 1:
        return [_sideTypes[0], _sideTypes[2], _sideTypes[5], _sideTypes[4]];
      case 2:
        return [_sideTypes[0], _sideTypes[3], _sideTypes[5], _sideTypes[1]];
      case 3:
        return [_sideTypes[0], _sideTypes[4], _sideTypes[5], _sideTypes[2]];
      case 4:
        return [_sideTypes[0], _sideTypes[1], _sideTypes[5], _sideTypes[3]];
    }
  }

  double widthFor(int side) {
    switch (side) {
      case 0:
      case 5:
        return x;
      case 1:
      case 3:
        return z;
      case 2:
      case 4:
        return z;
    }
  }

  double heightFor(int side) {
    switch (side) {
      case 0:
      case 5:
        return y;
      case 1:
      case 3:
        return y;
      case 2:
      case 4:
        return x;
    }
  }

  SvgResult toSvg() {
    // Work out the bounding box from the sub boxes.
    Iterable<SvgSection> sections = _sides
        .map((FlatPiece s) => s.toSvg())
        .where((SvgSection s) => s != null);
    print('Sides $_sides');
    return new SvgResult(sections: sections.toList());
  }
}
