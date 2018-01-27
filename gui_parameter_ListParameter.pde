/**
 * A dynamically generated GUI element that manages an ArrayList of {@link Tweakable}s and their individual GUI controls.
 * Uses a dropdown menu to select which object in the list is currently being controlled.
 */
public class ListParameter<T extends Tweakable> extends ParameterControl {
  private ArrayList<T> items;
  private ArrayList<ArrayList<ParameterControl>> itemParameters;
  private int currentIndex;

  private GWindow window;
  private int x, y;

  private GDropList dropList;

  /**
   * Creates a ListParameter.
   * @param obj          the object that contains the field to be controlled.
   * @param fieldName    the name of the field on the object that this should control. Should be of type <code>ArrayList&lt;T&gt;</code>.
   * @param labelText    the text displayed beside the control.
   * @param items        the list of items to be shown in the dropdown menu.
   */
  ListParameter(Object obj, String fieldName, String labelText, ArrayList<T> items) {
    super(labelText, obj, fieldName);
    this.items = items;

    this.currentIndex = 0;
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.window = window;
    this.x = x;
    this.y = y;
    this.createLabel(window, x, y);

    // Build list of item names for the dropdown list.
    String[] itemNames = new String[this.items.size()];
    for (int i = 0; i < itemNames.length; i++)
      itemNames[i] = this.items.get(i).getName();

    // Create dropdown list.
    this.dropList = new GDropList(window, x+labelWidth, y, tweakerWidth - labelWidth - x - 20, 100, 4);
    this.dropList.setItems(itemNames, 0);
    this.dropList.addEventHandler(this, "dropListChange");

    // Build and store list of each item's ParameterControls, and simultaneously create the GUI controls,
    // keeping track of the largest (tallest) group of GUI controls.
    this.itemParameters = new ArrayList<ArrayList<ParameterControl>>(this.items.size());
    int maxHeight = 0;
    for (T item : this.items) {
      ArrayList<ParameterControl> parameters = item.getParameters();

      this.itemParameters.add(parameters);

      // Create all the GUI controls for this item, but invisible.
      int yOffset = 20 + smallPadding;
      for (ParameterControl parameter : parameters) {
        yOffset += parameter.createGUIControls(window, x+largePadding, y+yOffset);
        yOffset += smallPadding;
        // Hide the controls for now.
        parameter.setVisible(false);
      }

      // If this is the tallest group of GUI controls yet, update the maxHeight.
      if (yOffset > maxHeight)
        maxHeight = yOffset;
    }

    // Unhide the first item's controls.
    this.setCurrentItemVisible(true);

    return maxHeight;
  }

  public void dropListChange(GDropList source, GEvent event) {
    this.setCurrentItemVisible(false);
    this.currentIndex = this.dropList.getSelectedIndex();
    this.setCurrentItemVisible(true);
  }

  void setCurrentItemVisible(boolean visible) {
    ArrayList<ParameterControl> parameters = this.itemParameters.get(this.currentIndex);
    for (ParameterControl parameter : parameters)
      parameter.setVisible(visible);
  }
}