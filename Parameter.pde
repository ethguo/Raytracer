public abstract class Parameter {
  Tweaker tweaker;
  
  abstract Object getValue();
  abstract int createGUIControls(GWindow window, int y); // Returns next y
}