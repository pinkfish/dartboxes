import 'svgresult.dart';
import 'edge.dart';
import 'svgpath.dart';
import 'settings.dart';
import 'flatpiecedecorator.dart';

///
/// Defines a flat piece in the object, this can be any shape/size and is
/// rendered as a sequence of sides.  The sides themselves can be straight
/// or curved.
///
class FlatPiece {
  List<Edge> edges = [];
  List<FlatPieceDecorator> decorators = [];

  /// The setup for this specific box.
  final Settings setup;

  FlatPiece(this.setup);

  SvgSection toSvg() {
    SvgPath path = new SvgPath();
    bool first = true;
    for (int i = 0; i < edges.length; i++) {
      edges[i].toSvg(path, first, edges[(i + edges.length - 1) % edges.length].edgeOffset(false),
          edges[(i + 1) % edges.length].edgeOffset(true));
      first = false;
    }
    // Close the piece.
    path.closePath();

    SvgSection section = SvgSection();
    section.addPath(path);
    // Now do all the decorators.
    for (FlatPieceDecorator decorator in decorators) {
      decorator.decorate(this, section);
    }
    return section;
  }
}
