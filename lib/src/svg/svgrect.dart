import 'package:xml/xml.dart';
import 'svgelement.dart';

///
/// A rectangle in the svg world.
///
class SvgRect extends SvgElement {
  final double x;
  final double y;
  final double width;
  final double height;

  SvgRect(this.x, this.y, this.width, this.height);

  @override
  void renderToInner(XmlBuilder builder) {
    builder.element('rect', nest: () {
      builder.attribute('x', x);
      builder.attribute('y', y);
      builder.attribute('width', width);
      builder.attribute('height', height);
    });
  }
}
