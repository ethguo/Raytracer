/**
 * An object that can be an entry in a {@link ListParameter} dropdown list. Each instance of a Tweakable has its own 
 * set of ParameterControls specific to that instance, which can be obtained with {@link getParameters}.
 */
interface Tweakable {
  /** Returns a human-friendly String that will identify this object in the dropdown list. */
  String getName();
  
  /** Returns a ArrayList of ParameterControls bound to modify this object. */
  ArrayList<ParameterControl> getParameters();
}