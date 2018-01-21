interface Tweakable {
  String getName();
  int createGUIControls(GWindow window, int x, int y);
  void setVisible(boolean visible);
}