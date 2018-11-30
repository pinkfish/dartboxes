import 'svgpath.dart';
import 'point.dart';

enum EdgeType {
  FingerJointPositive,
  FingerJointNegative,
  BlankEdge,
  LidNegative,
  LidPositive,
}
///
/// The basic edge class, everything else builds off this.
///
abstract class Edge {
  ///
  /// The edge is passed in how much in from the edge the connection is
  /// starting.  The edge should do a lineTo to get the right start pos.
  ///
  void toSvg(SvgPath path, bool first, double previousEdgeOffset, double nextEdgeOffset);

  double edgeOffset(bool next);
}
