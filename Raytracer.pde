import java.lang.reflect.Field;
import java.lang.reflect.Constructor;
import g4p_controls.*;

// Optionally override the default demo scene loaded at startup.
private String sceneFile = "";

// Constants for GUI sizing and spacing.
public final int renderWidth = 1200; // If the windows do not fit on your screen, try reducing this to 800.
public final int renderHeight = 800;
public final int tweakerWidth = 360;
public final int tweakerHeight = 800;
public final int largePadding = 20;
public final int smallPadding = 5;
public final int labelWidth = 100;
public final int sliderWidth = 100;

public Scene scene;
public Scene frozenScene;
public Tweaker tweaker;

public void settings() {
  // the size command must be put in settings() instead of setup() to be able to pass variables for arguments.
  size(renderWidth, renderHeight);
}

public void setup() {
  int xWindow = (displayWidth - renderWidth - tweakerWidth) / 2;
  int yWindow = (displayHeight - renderHeight) / 2;
  surface.setLocation(xWindow, yWindow);

  surface.setTitle("Raytracer");

  if (sceneFile.equals("")) {
    scene = new Scene();
    println("Demo scene loaded");
  }
  else {
    JSONObject j = loadJSONObject(sceneFile);
    scene = new Scene(j);
    println("Scene loaded from " + sceneFile);
  }

  // Create the second GUI window with the controls.
  createTweaker();

  noLoop();
}

public void draw() {
  int t0 = millis();

  // Prepare the pixels array.
  loadPixels();

  // Make a deep copy of the scene, so that it won't be affected if the scene is updated by the GUI in the middle of drawing.
  frozenScene = scene.copy();

  for (int imageY = 0; imageY < height; imageY++) {
    for (int imageX = 0; imageX < width; imageX++) {
      // For each pixel on the image, determine a primary ray for that pixel.
      Ray primaryRay = getPrimaryRay(imageX, imageY);

      boolean hit = primaryRay.trace(frozenScene);

      Vector3 pixelColor;
      if (hit)
        // If the primary hit something, get the shading at that point.
        pixelColor = primaryRay.getPointShading(frozenScene);
      else
        // If the primary ray did not hit anything, set this pixel to the sky color.
        pixelColor = frozenScene.skyColor;

      pixels[imageY*width+imageX] = pixelColor.toColorPrimitive();
    }
  }

  // Blit the updated pixels array onto the screen.
  updatePixels();

  // Print how long it took to generate the image.
  int elapsedTime = millis() - t0;
  println("Image rendered. Elapsed time: " + elapsedTime + " ms");
}

/**
 * Creates a primary ray from the camera origin, through a specified pixel on the image plane. (See Fig. 1 in the design document)
 * @param  imageX  x coordinate of pixel on the image plane.
 * @param  imageY  y coordinate of pixel on the image plane.
 * @return         a Ray with origin at the camera origin and direction pointing through the specified pixel on the image plane.
 */
private Ray getPrimaryRay(int imageX, int imageY) {
  float fovRad = frozenScene.fov * PI / 180;

  float aspectRatio = (float) width / height;

  float cameraPlaneX = (2 * (imageX + 0.5) / (width) - 1) * aspectRatio * tan(fovRad/2);
  float cameraPlaneY = -(2 * (imageY + 0.5) / (height) - 1) * tan(fovRad/2);

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, -1);
  direction.normalize();

  return new Ray(frozenScene.cameraOrigin, direction);
}

/**
 * Creates the Tweaker window and adds the Scene controls.
 */
private void createTweaker() {
  tweaker = new Tweaker(this);
  
  tweaker.addParameter(new Vector3Parameter(scene, "cameraOrigin", "Camera Origin", scene.cameraOrigin, -5, 5));
  tweaker.addParameter(new FloatParameter(scene, "fov", "Field of View", scene.fov, 5.0, 175.0));
  tweaker.addParameter(new Vector3Parameter(scene, "skyColor", "Sky Color", scene.skyColor, true));
  tweaker.addParameter(new FloatParameter(scene, "shadowBias", "Shadow Bias", scene.shadowBias));
  tweaker.addParameter(new ListParameter<SceneObject>(scene, "sceneObjects", "Scene Objects", scene.sceneObjects));
  tweaker.addParameter(new ListParameter<Light>(scene, "lights", "Lights", scene.lights));

  tweaker.draw();
}

/**
 * Callback for the Save Scene button. This is called after the user selects a file or closes the file selection dialog.
 * @param file passed by the file selection dialog.
 */
public void saveScene(File file) {
  // If the user canceled the selection, the file will be null.
  if (file == null) {
    println("Selection canceled");
    return;
  }

  String path = file.getAbsolutePath();

  // Serialize the current Scene into a new JSONObject and write it to the given file.
  JSONObject j = scene.toJSONObject();
  saveJSONObject(j, path);
  println("Scene saved to " + path);
}

/**
 * Callback for the Load Scene button. This is called after the user selects a file or closes the file selection dialog.
 * @param file passed by the file selection dialog.
 */
public void loadScene(File file) {
  // If the user canceled the selection, the file will be null.
  if (file == null) {
    println("Selection canceled");
    return;
  }

  String path = file.getAbsolutePath();

  // Read the JSONObject from the given file and deserialize it into a new Scene.
  JSONObject j = loadJSONObject(path);
  scene = new Scene(j);
  println("Scene loaded from " + path);

  // Recreate the tweaker window.
  tweaker.destroy();
  createTweaker();
  // Redraw the scene.
  redraw();
}
