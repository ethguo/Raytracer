int imageWidth = 25;
int imageHeight = 25;
float fov = 90;
Vector3 origin = new Vector3(0, 0, 0);

float imagePixelWidth;
float imagePixelHeight;
float fovRad;

Sphere sceneObject = new Sphere(new Vector3(0, 0, 2), 1);

void setup() {
  size(400, 400);

  fovRad = fov * PI / 180;

  imagePixelWidth = width / imageWidth;
  imagePixelHeight = height / imageHeight;

  noLoop();
}

void draw() {
  // loadPixels();

  background(0);
  fill(255);
  noStroke();

  for (int imageY = 0; imageY < imageHeight; imageY++) {
    for (int imageX = 0; imageX < imageWidth; imageX++) {
      Ray primaryRay = getPrimaryRay(imageX, imageY);
      printt(primaryRay);

      float hitT = sceneObject.rayHit(primaryRay);
      
      if (hitT != 0) {
        rect(imageX * imagePixelWidth, imageY * imagePixelHeight, imagePixelWidth, imagePixelHeight);
      }

      println();
    }
    println();
  }

  // updatePixels();
}

Ray getPrimaryRay(int imageX, int imageY) {
  float cameraPlaneX = 2 * (imageX + 0.5) / imageWidth - 1;
  float cameraPlaneY = 2 * (imageY + 0.5) / imageHeight - 1;

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, 1);
  direction.normalize();

  return new Ray(origin, direction);
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading