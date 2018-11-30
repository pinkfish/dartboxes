import 'package:xml/xml.dart';
import 'svgstyle.dart';

///
/// The abstract svg element to use in the system.
///
abstract class SvgElement {
  SvgStyle style;
  String id;


  void renderToInner(XmlBuilder builder);

  void renderTo(XmlBuilder builder) {
    if (style != null) {
      builder.attribute('fill', style.fill);
      builder.attribute('stroke', style.strokeColor);
      builder.attribute('stroke-width', style.strokeWidth);
    }
    if (id != null) {
      builder.attribute('id', id);
    }
    renderTo(builder);
  }
}