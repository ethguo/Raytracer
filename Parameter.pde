public abstract class Parameter {
  Tweaker tweaker;
  Object obj;
  String fieldName;
  Field field;

  Parameter(Object obj, String fieldName) {
  	this.obj = obj;
  	this.fieldName = fieldName;
  	try {
    	this.field = obj.getClass().getField(fieldName);
    }
    catch (ReflectiveOperationException e) {
      System.err.println(e.getClass().getSimpleName() + ": " + e.getMessage());
    }
  }
  
  abstract Object getValue();
  abstract int createGUIControls(GWindow window, int y); // Returns next y coordinate
}