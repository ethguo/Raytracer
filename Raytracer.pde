import java.util.Map;
import java.util.LinkedHashMap;
import g4p_controls.*;

int imageWidth = 600;
int imageHeight = 600;
float fov = 75;
Vector3 origin = new Vector3(0, 0, 0);
color skyColor = #8CBED6;
float shadowBias = 1e-4;

float imagePixelWidth;
float imagePixelHeight;

SceneObject[] sceneObjects = new SceneObject[] {
  new Sphere(new Vector3(0, -1, -4), 1, 0.9),
  new Sphere(new Vector3(1, 0, -7), 2, 0.8),
  new Sphere(new Vector3(-1, 1.5, -5), 0.33, 0.9),
  new Plane(new Vector3(0, -2, 0), new Vector3(0, 1, 0), 0.6)
};

Light[] lights = new Light[] {
  new DirectionalLight(new Vector3(0, -1, 0).normalized(), #CCCCCC, 1),
  new DirectionalLight(new Vector3(1, -1, -1).normalized(), #FFCC99, PI),
  new DirectionalLight(new Vector3(-1, -0.5, -0.5).normalized(), #3399FF, 1.5),
};

void setup() {
  size(600, 600);
  surface.setTitle("Raytracer");

  Tweaker tweaker = new Tweaker(this);
  tweaker.addParameter("fov", new FloatParameter(75.0, 5.0, 175.0));
  // tweaker.addParameter("obj1_position", new VectorParameter<Vector3>(75, 5, 175));

  tweaker.draw();

  imagePixelWidth = width / imageWidth;
  imagePixelHeight = height / imageHeight;

  noLoop();
}

void draw() {
  loadPixels();
  int t0 = millis();

  // drawGrid(imagePixelWidth, imagePixelWidth);
  // noStroke();

  for (int imageY = 0; imageY < imageHeight; imageY++) {
    for (int imageX = 0; imageX < imageWidth; imageX++) {
      // print("Pixel[" + imageX + ", " + imageY + "] ");
      Ray primaryRay = getPrimaryRay(imageX, imageY);

      boolean hit = primaryRay.cast();
      if (hit) {
        Vector3 pointShading = primaryRay.getPointShading();
        pixels[imageY*width+imageX] = pointShading.toColor();
      }
      else {
        pixels[imageY*width+imageX] = skyColor;
      }
    }
  }
  updatePixels();

  int elapsedTime = millis() - t0;
  println("Elapsed time: " + elapsedTime + " ms");
}

Ray getPrimaryRay(int imageX, int imageY) {
  float fovRad = fov * PI / 180;

  float aspectRatio = (float) imageWidth / imageHeight;

  float cameraPlaneX = (2 * (imageX + 0.5) / (imageWidth) - 1) * aspectRatio * tan(fovRad/2);
  float cameraPlaneY = -(2 * (imageY + 0.5) / (imageHeight) - 1) * tan(fovRad/2);

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, -1);
  direction.normalize();

  return new Ray(origin, direction);
}

void drawGrid(float cellWidth, float cellHeight) {
  stroke(0);
  for (int x = 0; x < width; x += cellWidth)
    line(x, 0, x, height);

  for (int y = 0; y < height; y += cellHeight)
    line(0, y, width, y);
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/ligth-and-shadows