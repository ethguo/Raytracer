int imageWidth = 5;
int imageHeight = 5;
float fov = 90;
Vector3 origin = new Vector3(0, 0, 0);

float fovRad;

Sphere sceneObject = new Sphere(1);


void setup() {
  size(400, 400);

  fovRad = fov * PI / 180;

  noLoop();
}

void draw() {
  loadPixels();

  for (int imageY = 0; imageY < imageHeight; imageY++) {
    for (int imageX = 0; imageX < imageWidth; imageX++) {
      Ray primaryRay = getPrimaryRay(imageX, imageY);
      println(primaryRay);
    }
  }

  updatePixels();
}

Ray getPrimaryRay(int imageX, int imageY) {
  float cameraPlaneX = 2 * (imageX + 0.5) / imageWidth - 1;
  float cameraPlaneY = 2 * (imageY + 0.5) / imageHeight - 1;

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, 1);
  direction.normalize();

  return new Ray(origin, direction);
}
