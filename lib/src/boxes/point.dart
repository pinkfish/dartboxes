import 'dart:math';

///
/// A point represent a spot in the svg world.
///
class Point {
  double x;
  double y;

  /// Create a new point with the start x and y.
  Point(this.x, this.y) {
    // Round to the nearest 100th.
    this.x = (this.x * 100).roundToDouble() / 100;
    this.y = (this.y * 100).roundToDouble() / 100;
  }

  @override
  bool operator ==(other) {
    if (other is Point) {
      return other.x == x && other.y == y;
    }
    return false;
  }

  ///
  /// Add a point offset onto this point.
  ///
  Point add(Point p) {
    return Point(x + p.x, y + p.y);
  }

  /// Gets the hash code for this object
  int get hashCode => (((x * 17) * 31 + y) * 100).toInt();

  double _dp(double val, double places){
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  ///
  /// Transform the point with an angle to the point moved to that angle.
  ///
  Point transformRadians(double angleRadians) {
    return Point(_dp(x * cos(angleRadians) - y * sin(angleRadians), 2),
        _dp(y * cos(angleRadians) + x * sin(angleRadians), 2));
  }

  ///
  /// Transforms the point the specified mumber of degrees.
  ///
  Point transformDegree(double degrees) {
    Point newPt = transformRadians(degrees * pi / 180.0);
    return newPt;
  }

  @override
  String toString() {
    return 'Point{x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}';
  }
}

///
/// A rectangle to control the bounding boxes.
///
class Rectangle {
  final Point topLeft;
  final Point bottomRight;

  /// Create a new rectangle with the start bounds.
  Rectangle(this.topLeft, this.bottomRight) {
    assert(this.topLeft.x <= this.bottomRight.x);
    assert(this.topLeft.y <= this.bottomRight.y);
  }

  /// Expand the region by adding this point into the rectangle.
  void addPoint(Point p) {
    if (p.x > this.bottomRight.x) {
      bottomRight.x = p.x;
    }
    if (p.y > this.bottomRight.y) {
      bottomRight.y = p.y;
    }
    if (p.x < this.topLeft.x) {
      topLeft.x = p.x;
    }
    if (p.y < this.topLeft.y) {
      topLeft.y = p.y;
    }
  }

  /// Expand the region by adding this rectangle into region.
  void addRectangle(Rectangle r) {
    if (r.bottomRight.x > bottomRight.x) {
      bottomRight.x = r.bottomRight.x;
    }
    if (r.bottomRight.y > bottomRight.y) {
      bottomRight.y = r.bottomRight.y;
    }
    if (r.topLeft.x < topLeft.x) {
      topLeft.x = r.topLeft.x;
    }
    if (r.topLeft.y < topLeft.y) {
      topLeft.y = r.topLeft.y;
    }
  }
}
