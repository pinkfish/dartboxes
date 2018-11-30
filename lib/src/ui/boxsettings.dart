enum TopSide { Lid, Open, Closed }

enum LidType { PressFit, Hinged, Cap }

class BoxSettings {
  double x = 100.0;
  double y = 200.0;
  double z = 50.0;
  double boardThickness = 6.0;
  double burnCorrection = 0.1;
  TopSide topSide = TopSide.Lid;

  // If we have a hinged lid or not.
  LidType hingedLid = LidType.PressFit;

  // Only valid when a hinge is asked for.
  int numHingesInGroup = 3;
  int numHingeGroups = 2;

  double lidHeight = 24.0;

  // Max size of the material.
  double materialWidth = 275.0;
  double materialHeight = 275.0;

  // How many sides the box has, looking from the top.
  int numMainSides = 4;
  List<bool> sidesExist = List<bool>.filled(5, true);

  @override
  String toString() {
    return 'BoxSettings{x: $x, y: $y, z: $z, boardThickness: $boardThickness, burnCorrection: $burnCorrection}';
  }
}
