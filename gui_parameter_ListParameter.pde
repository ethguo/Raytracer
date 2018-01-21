public class ListParameter<T extends NamedObject> extends Parameter {
  ArrayList<T> list;
  int currentIndex;
  T currentItem;

  private GDropList dropList;

  ListParameter(Object obj, String updateMethodName, String labelText, ArrayList<T> list) {
    super(labelText, obj, updateMethodName, ArrayList.class);
    this.list = list;
    this.labelText = labelText;
  }

  int createGUIControls(GWindow window, int x, int y) {
    this.createLabel(window, x, y);

    String[] listNames = new String[list.size()];
    for (int i = 0; i < listNames.length; i++) {
      listNames[i] = list.get(i).getName();
    }

    this.dropList = new GDropList(window, x+100, y, 160, 120, 5);
    this.dropList.setItems(listNames, 0);
    this.dropList.addEventHandler(this, "dropListChange");

    return 20;
  }

  public void dropListChange(GDropList source, GEvent event) {
    this.currentIndex = this.dropList.getSelectedIndex();
    this.currentItem = this.list.get(this.currentIndex);
  }
}