import java.util.Map;
import java.util.LinkedHashMap;
import java.lang.reflect.Field;
import java.lang.reflect.Constructor;
import g4p_controls.*;

String sceneFile = "scene.json";

final int renderWidth = 800;
final int renderHeight = 800;
final int tweakerWidth = 360;
final int tweakerHeight = 800;
final int largePadding = 20;
final int smallPadding = 5;
final int labelWidth = 100;
final int sliderWidth = 100;

Scene scene;
Scene frozenScene;
Tweaker tweaker;

void settings() {
  size(renderWidth, renderHeight);
}

void setup() {
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

void draw() {
  int t0 = millis();

  loadPixels();

  // Make a deep copy of the scene, so that it won't be affected if the scene is updated by the GUI in the middle of drawing.
  frozenScene = scene.copy();

  for (int imageY = 0; imageY < height; imageY++) {
    for (int imageX = 0; imageX < width; imageX++) {
      Ray primaryRay = getPrimaryRay(imageX, imageY);

      boolean hit = primaryRay.trace(frozenScene);
      if (hit) {
        Vector3 pointShading = primaryRay.getPointShading(frozenScene);
        pixels[imageY*width+imageX] = pointShading.toColorPrimitive();
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

public void saveScene(File file) {
  if (file == null)
    println("Selection canceled");
  else {
    String path = file.getAbsolutePath();

    JSONObject j = scene.toJSONObject();
    saveJSONObject(j, path);
    println("Scene saved to " + path);
  }
}

public void loadScene(File file) {
  if (file == null)
    println("Selection canceled");
  else {
    String path = file.getAbsolutePath();

    JSONObject j = loadJSONObject(path);
    scene = new Scene(j);
    println("Scene loaded from " + path);

    tweaker.destroy();
    createTweaker();
    redraw();
  }
}

void createTweaker() {
  tweaker = new Tweaker(this);
  
  tweaker.addParameter(new FloatParameter(scene, "fov", "Field of View", scene.fov, 5.0, 175.0));
  tweaker.addParameter(new FloatParameter(scene, "shadowBias", "Shadow Bias", scene.shadowBias));
  tweaker.addParameter(new Vector3Parameter(scene, "cameraOrigin", "Camera Origin", scene.cameraOrigin, -5, 5));
  tweaker.addParameter(new Vector3Parameter(scene, "skyColor", "Sky Color", scene.skyColor, true));
  tweaker.addParameter(new ListParameter<SceneObject>(scene, "sceneObjects", "Scene Objects", scene.sceneObjects));
  tweaker.addParameter(new ListParameter<Light>(scene, "lights", "Lights", scene.lights));

  tweaker.draw();
}

/* Next:
    * Design Document
    * RGB Albedo (see https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading)
    * Specular - Phong/BRDF (https://www.scratchapixel.com/lessons/3d-basic-rendering/phong-shader-BRDF)
    * Reflection and Refraction (https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/reflection-refraction-fresnel)
 */