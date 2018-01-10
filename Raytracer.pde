int imageWidth = 20;
int imageHeight = 20;

Sphere sceneObject = new Sphere();

void setup() {
  size(400, 400);

  noLoop();
}

void draw() {
  loadPixels();

  for (int imageY = 0; imageY < imageHeight; imageY++) {
    for (int imageX = 0; imageX < imageWidth; imageX++) {
      Ray primaryRay = new Ray();
    }
  }

  updatePixels();
}