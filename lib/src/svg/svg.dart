import 'package:xml/xml.dart';
import 'svgelement.dart';

///
/// Class to represent a Svg file.
/// 
class Svg {
  double height;
  double width;
  String id;
  String title;
  List<SvgElement> elements;

  XmlNode renderTo(XmlBuilder builder) {
    builder.element('svg', nest: () {
      builder.attribute("id", id);
      builder.attribute("viewBox", "0 0 $width $height");
      for (SvgElement e in elements) {
        e.renderTo(builder);
      }
    });
    return builder.build();
  }
}