/// Class that control the FAB
class FabController {
  void Function()? open;
  void Function()? close;
  void Function()? toggle;
  bool Function()? getState;

  /// Constructor
  FabController({this.open, this.close, this.toggle, this.getState});
}