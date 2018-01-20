import java.util.Map;
import java.util.LinkedHashMap;
import java.lang.reflect.Field;
import java.lang.reflect.Constructor;
import g4p_controls.*;

String sceneFile = "scene.json";

Scene scene;
Tweaker tweaker;

void setup() {
  size(600, 600);
  surface.setTitle("Raytracer");
  surface.setLocation(displayWidth/2-450, displayHeight/2-300);

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
  tweaker.addParameter("fov", new FloatParameter(75.0, 5.0, 175.0));
  // tweaker.addParameter("obj1_position", new VectorParameter<Vector3>(75, 5, 175));

  tweaker.draw();

  noLoop();
}

void draw() {
  int t0 = millis();

  loadPixels();

  // drawGrid(imagePixelWidth, imagePixelWidth);
  // noStroke();

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
        pixels[imageY*width+imageX] = scene.skyColor.toColorPrimitive();
      }
    }
  }

  updatePixels();

  int elapsedTime = millis() - t0;
  println("Elapsed time: " + elapsedTime + " ms");
}

Ray getPrimaryRay(int imageX, int imageY) {
  float fovRad = scene.fov * PI / 180;

  float aspectRatio = (float) width / height;

  float cameraPlaneX = (2 * (imageX + 0.5) / (width) - 1) * aspectRatio * tan(fovRad/2);
  float cameraPlaneY = -(2 * (imageY + 0.5) / (height) - 1) * tan(fovRad/2);

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, -1);
  direction.normalize();

  return new Ray(scene.origin, direction);
}

void drawGrid(float cellWidth, float cellHeight) {
  stroke(0);
  for (int x = 0; x < width; x += cellWidth)
    line(x, 0, x, height);

  for (int y = 0; y < height; y += cellHeight)
    line(0, y, width, y);
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/ligth-and-shadows