int imageWidth = 400;
int imageHeight = 400;
float fov = 75;
Vector3 origin = new Vector3(0, 0, 0);
color skyColor = #8CBED6;
float shadowBias = 1e-4;

float imagePixelWidth;
float imagePixelHeight;

SceneObject[] sceneObjects = new SceneObject[] {
  new Sphere(new Vector3(0, -0.5, -3), 1, 0.9),
  new Sphere(new Vector3(1, 0.5, -4), 1, 0.9),
  new Sphere(new Vector3(-1, 0, -2), 0.2, 0.9),
  new Plane(new Vector3(0, -1, 0), new Vector3(0, 1, 0), 0.9)
};

Light[] lights = new Light[] {
  new DirectionalLight(new Vector3(1, -1, -1).normalized(), #FF9933, PI),
  new DirectionalLight(new Vector3(-1, -0.5, -0.5).normalized(), #3399FF, 1.5),
};

void setup() {
  size(400, 400);

  imagePixelWidth = width / imageWidth;
  imagePixelHeight = height / imageHeight;

  noLoop();
}

void draw() {
  // loadPixels();
  int t0 = millis();

  background(skyColor);
  fill(255);
  noStroke();

  for (int imageY = 0; imageY < imageHeight; imageY++) {
    for (int imageX = 0; imageX < imageWidth; imageX++) {
      Ray primaryRay = getPrimaryRay(imageX, imageY);

      boolean hit = primaryRay.cast();
      if (hit) {
        Vector3 pointShading = primaryRay.getPointShading();
        fill(pointShading.toColor());
        rect(imageX * imagePixelWidth, imageY * imagePixelHeight, imagePixelWidth, imagePixelHeight);
      }
    }
  }

  int elapsedTime = millis() - t0;
  println("Elapsed time: " + elapsedTime + " ms");

  // updatePixels();
}

Ray getPrimaryRay(int imageX, int imageY) {
  float fovRad = fov * PI / 180;

  float cameraPlaneX = (2 * (imageX + 0.5) / (imageWidth) - 1) * tan(fovRad/2);
  float cameraPlaneY = -(2 * (imageY + 0.5) / (imageHeight) - 1) * tan(fovRad/2);

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, -1);
  direction.normalize();

  return new Ray(origin, direction);
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/ligth-and-shadows