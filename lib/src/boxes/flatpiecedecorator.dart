import 'settings.dart';
import 'flatpiece.dart';
import 'svgresult.dart';

///
/// The decorator is for things that go inside the flat piece.  This will be
/// passed in the flat bit itself and the details of the edges, from there
/// the decorator can layout extra bits inside the flat bit.
///
abstract class FlatPieceDecorator {
  ///
  /// Adds any extra lines/pieces into the result
  ///
  void decorate(FlatPiece piece, SvgSection section);
}

