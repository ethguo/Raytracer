/**
 * Manages the "Tweaker" window and all the GUI controls that are drawn onto it.
 */
public class Tweaker {
  private ArrayList<ParameterControl> parameters;

  private PApplet applet;
  /** This timer (not drawn on the GUI) is used to slightly delay re-rendering the scene, to minimize jumpyness. */
  private GTimer updateTimer;
  private GWindow tweakerWindow;
  private GButton saveButton;
  private GButton loadButton;

  Tweaker(PApplet applet) {
    this.applet = applet;
    this.parameters = new ArrayList<ParameterControl>();
  }

  void draw() {
    // G4P setup configuration
    G4P.messagesEnabled(false);
    G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
    G4P.setCursor(ARROW);

    // Create the updateTimer.
    this.updateTimer = new GTimer(Raytracer.this, this, "updateTimerTrigger", 100);

    // Create the actual GWindow.
    int xTweakerWindow = (displayWidth + renderWidth - tweakerWidth) / 2 + 2;
    int yTweakerWindow = (displayHeight - tweakerHeight) / 2;
    this.tweakerWindow = GWindow.getWindow(Raytracer.this, "Tweaker", xTweakerWindow, yTweakerWindow, tweakerWidth, tweakerHeight, JAVA2D);
    this.tweakerWindow.noLoop();
    this.tweakerWindow.setActionOnClose(G4P.EXIT_APP);
    this.tweakerWindow.addDrawHandler(this, "tweakerWindowDraw");

    // Create the save and load buttons.
    int xSaveButton = (tweakerWidth - largePadding) / 2 - 100;
    int xLoadButton = (tweakerWidth + largePadding) / 2;
    int yButton = tweakerHeight - largePadding - 20;

    this.saveButton = new GButton(this.tweakerWindow, xSaveButton, yButton, 100, 20, "Save Scene");
    this.saveButton.addEventHandler(this, "saveButtonClicked");

    this.loadButton = new GButton(this.tweakerWindow, xLoadButton, yButton, 100, 20, "Load Scene");
    this.loadButton.addEventHandler(this, "loadButtonClicked");

    // Dynamically create all the ParameterControls.
    int yOffset = largePadding;
    for(ParameterControl parameter : this.parameters) {
      yOffset += parameter.createGUIControls(this.tweakerWindow, largePadding, yOffset);
      yOffset += largePadding;
    }

    // Start the event loop on the secondary window.
    this.tweakerWindow.loop();
  }

  /** Triggers the update timer. The scene will be re-rendered only if the GUI controls are not changed again in the next 100ms. */
  public void update() {
    // Reset the updateTimer and start it again.
    this.updateTimer.stop();
    this.updateTimer.start(1);
  }

  /** Add a ParameterControl to the master list. Must be called before {@link draw}. */
  void addParameter(ParameterControl parameter) {
    this.parameters.add(parameter);
  }

  /** Force closes the window to prepare for deletion. */
  void destroy() {
    this.tweakerWindow.setActionOnClose(G4P.CLOSE_WINDOW);
    this.tweakerWindow.forceClose();
  }

  synchronized public void tweakerWindowDraw(PApplet appc, GWinData data) {
    appc.background(230);
  }

  /** Callback for the {@link updateTimer}. */
  public void updateTimerTrigger(GTimer source) {
    redraw();
  }

  /** Callback for the save button. */
  public void saveButtonClicked(GButton source, GEvent event) {
    selectOutput("Select file", "saveScene", new File(dataPath("my-scene.json")));
  }

  /** Callback for the load button. */
  public void loadButtonClicked(GButton source, GEvent event) {
    selectInput("Select file", "loadScene", new File(dataPath("my-scene.json")));
  }
}