import 'svgpath.dart';
import 'point.dart';

///
/// A section is the region covered by one edge.
///
class SvgSection {
  final List<SvgPath> _elements;
  final Rectangle _boundingBox;

  ///
  /// Add the specific path to the section.
  ///
  void addPath(SvgPath path) {
    _elements.add(path);
    _boundingBox.addRectangle(path.boundingBox);
  }

  /// Get the bounding box for this section.  This can be used to layout
  /// the sections in respect to each other.  Everything in a section will
  /// always stay int he same place to the items in the section, sections will
  /// lay themselves out independent to each other.
  Rectangle get boundingBox => _boundingBox;

  SvgSection()
      : _elements = [],
        _boundingBox = Rectangle(Point(0, 0), Point(0, 0));

  String toStringRelativeTo(Point p) {
    String ret = "";
    for (SvgPath path in _elements) {
      ret += path.toStringRelative(p);
    }
    return ret;
  }
}

///
/// The result for the whole thing.  This contains all the sections for the
/// various flat pieces.
///
class SvgResult {
  final List<SvgSection> _sections;

  SvgResult({List<SvgSection> sections}) : _sections = sections ?? [];

  void addSection(SvgSection section) {
    assert(section != null);
    _sections.add(section);
  }

  String toString() {
    // Put all the sections in a row right now.
    Point start = Point(0, 0);
    String res = "";
    int pos = 0;
    double maxY = 0.0;
    for (SvgSection section in _sections) {
      assert(section != null);
      res += section.toStringRelativeTo(start);
      if (section.boundingBox.bottomRight.y > maxY) {
        maxY = section.boundingBox.bottomRight.y;
      }
      pos++;
      if (pos < 3) {
        start.x += section.boundingBox.bottomRight.x;
      } else {
        start.x = 0;
        start.y += maxY;
        maxY = 0.0;
        pos = 0;
      }
    }
    return res;
  }
}
