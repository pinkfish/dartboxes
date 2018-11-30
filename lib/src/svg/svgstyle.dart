enum FillType { none }

///
/// The style to apply to the svg element.
///
class SvgStyle {
  final String fill;
  final String strokeColor;
  final double strokeWidth;

  SvgStyle(
      {this.fill = "none", this.strokeColor = "black", this.strokeWidth = 1});

  String toString() {
    return "fill:$fill;stroke:$strokeColor;strokeWidth=${strokeWidth}";
  }
}
