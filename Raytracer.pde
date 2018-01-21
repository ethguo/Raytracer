import java.util.Map;
import java.util.LinkedHashMap;
import java.lang.reflect.Field;
import java.lang.reflect.Constructor;
import g4p_controls.*;

String sceneFile = "scene.json";

Scene scene;
Scene frozenScene;
Tweaker tweaker;

void setup() {
  size(800, 800);
  surface.setTitle("Raytracer");
  surface.setLocation(displayWidth/2-550, displayHeight/2-400);

  if (sceneFile.equals("")) {
    scene = new Scene();
    println("Demo scene loaded");
  }
  else {
    JSONObject j = loadJSONObject(sceneFile);
    scene = new Scene(j);
    println("Scene loaded from " + sceneFile);
  }
  // JSONObject j2 = scene.toJSONObject();
  // saveJSONObject(j2, "data/scene.json");

  tweaker = new Tweaker(this);
  tweaker.addParameter(new FloatParameter(scene, "fov", "Field of View", scene.fov, 5.0, 175.0));
  tweaker.addParameter(new FloatParameter(scene, "shadowBias", "Shadow Bias", scene.shadowBias));
  tweaker.addParameter(new Vector3Parameter(scene, "cameraOrigin", "Camera Origin", scene.cameraOrigin, -5, 5));
  tweaker.addParameter(new Vector3Parameter(scene, "skyColor", "Sky Color", scene.skyColor, true));
  tweaker.addParameter(new ListParameter<SceneObject>(scene, "sceneObjects", "Scene Objects", scene.sceneObjects));

  tweaker.draw();

  noLoop();
}

void draw() {
  int t0 = millis();

  loadPixels();

  // drawGrid(imagePixelWidth, imagePixelWidth);
  // noStroke();

  // Make a deep copy of the scene, so that it won't be affected if the scene is updated by the GUI in the middle of drawing.
  frozenScene = scene.copy();

  for (int imageY = 0; imageY < height; imageY++) {
    for (int imageX = 0; imageX < width; imageX++) {
      // print("Pixel[" + imageX + ", " + imageY + "] ");
      Ray primaryRay = getPrimaryRay(imageX, imageY);

      boolean hit = primaryRay.cast();
      if (hit) {
        Vector3 pointShading = primaryRay.getPointShading();
        color pointColor = pointShading.toColorPrimitive();
        pixels[imageY*width+imageX] = pointColor;
      }
      else {
        pixels[imageY*width+imageX] = frozenScene.skyColor.toColorPrimitive();
      }
    }
  }

  updatePixels();

  int elapsedTime = millis() - t0;
  println("Elapsed time: " + elapsedTime + " ms");
}

Ray getPrimaryRay(int imageX, int imageY) {
  float fovRad = frozenScene.fov * PI / 180;

  float aspectRatio = (float) width / height;

  float cameraPlaneX = (2 * (imageX + 0.5) / (width) - 1) * aspectRatio * tan(fovRad/2);
  float cameraPlaneY = -(2 * (imageY + 0.5) / (height) - 1) * tan(fovRad/2);

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, -1);
  direction.normalize();

  return new Ray(frozenScene.cameraOrigin, direction);
}

void drawGrid(float cellWidth, float cellHeight) {
  stroke(0);
  for (int x = 0; x < width; x += cellWidth)
    line(x, 0, x, height);

  for (int y = 0; y < height; y += cellHeight)
    line(0, y, width, y);
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/ligth-and-shadows