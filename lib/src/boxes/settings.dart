class LidEdgeSettings {
  /// This is the percentage of the side to use as a tab.
  double tabSize = 0.3;

  /// The min size for the tab.
  double minSize = 24.0;
}

class FingerEdgeSettings {
  /// minimum width of the positive fingers (relative to board width)
  final double positiveFinger = 2.0;

  /// extra space to allow movement, this only effects the output.
  final double play = 0.0;

  /// minimum width of the negative fingers (relative to board width)
  final double negativeFinger = 2.0;
}

class Settings {
  double boardWidth = 6.0;
  double burnCorrection = 0.1;

  /// These are all in multiples of the board width
  /// The extra space at the start/end of the board for the edges
  /// (fingers/lids). (relative to board width)
  final double extraSpace = 1.0;

  LidEdgeSettings lidSettings = LidEdgeSettings();
  FingerEdgeSettings fingerSettings = FingerEdgeSettings();
}
