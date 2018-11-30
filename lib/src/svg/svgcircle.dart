import 'package:xml/xml.dart';
import 'svgelement.dart';

///
/// A circle in the svg world.
///
class SvgCircle extends SvgElement {
  double centerX;
  double centerY;
  double radius;

  @override
  void renderToInner(XmlBuilder builder) {
    builder.element('circle', nest: () {
      builder.attribute('cx', centerX);
      builder.attribute('cy', centerY);
      builder.attribute('r', radius);
    });
  }
}
