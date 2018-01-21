public class ListParameter<T extends Tweakable> extends Parameter {
  ArrayList<T> list;
  T currentItem;

  private GWindow window;
  private int x, y;

  private GDropList dropList;

  ListParameter(Object obj, String fieldName, String labelText, ArrayList<T> list) {
    super(labelText, obj, fieldName);
    this.list = list;
    this.labelText = labelText;

    this.currentItem = list.get(0);
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.window = window;
    this.x = x;
    this.y = y;
    this.createLabel(window, x, y);

    String[] listNames = new String[list.size()];
    for (int i = 0; i < listNames.length; i++) {
      listNames[i] = list.get(i).getName();
    }

    this.dropList = new GDropList(window, x+100, y, 160, 120, 5);
    this.dropList.setItems(listNames, 0);
    this.dropList.addEventHandler(this, "dropListChange");
    
    this.currentItem.createGUIControls(window, x, y+20);

    return 20;
  }

  public void dropListChange(GDropList source, GEvent event) {
    this.currentItem.setVisible(false);

    int index = this.dropList.getSelectedIndex();
    this.currentItem = this.list.get(index);

    this.currentItem.createGUIControls(window, x, y+20);
  }
}