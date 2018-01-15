abstract class Parameter<T> {
  abstract T getValue();
  abstract void createGUIControls(GWindow window, int y);
}