int imageWidth = 400;
int imageHeight = 400;
float fov = 75;
Vector3 origin = new Vector3(0, 0, 0);
color skyColor = #8CBED6;

float fovRad;
float imagePixelWidth;
float imagePixelHeight;

SceneObject[] sceneObjects = new SceneObject[]{
  new Sphere(new Vector3(1, -0.5, -3), 1),
  new Sphere(new Vector3(1, 0, -2), 0.5)
};

void setup() {
  size(400, 400);

  fovRad = fov * PI / 180;
  imagePixelWidth = width / imageWidth;
  imagePixelHeight = height / imageHeight;

  noLoop();
}

void draw() {
  // loadPixels();

  background(skyColor);
  fill(255);
  noStroke();

  for (SceneObject sceneObject : sceneObjects) {
    for (int imageY = 0; imageY < imageHeight; imageY++) {
      for (int imageX = 0; imageX < imageWidth; imageX++) {
        Ray primaryRay = getPrimaryRay(imageX, imageY);
        // printt(primaryRay);

        float hitT = sceneObject.rayHit(primaryRay);
        
        if (hitT != 0) {
          Vector3 hit = primaryRay.solve(hitT);
          Vector3 normal = sceneObject.getNormal(hit);
          float facingRatio = max(0, -primaryRay.direction.dotProduct(normal));
          fill(facingRatio * 255);
          rect(imageX * imagePixelWidth, imageY * imagePixelHeight, imagePixelWidth, imagePixelHeight);
        }

        // println();
      }
      // println();
    }
  }

  // updatePixels();
}

Ray getPrimaryRay(int imageX, int imageY) {
  float cameraPlaneX = (2 * (imageX + 0.5) / (imageWidth) - 1) * tan(fovRad/2);
  float cameraPlaneY = (2 * (imageY + 0.5) / (imageHeight) - 1) * tan(fovRad/2);

  Vector3 direction = new Vector3(cameraPlaneX, cameraPlaneY, -1);
  direction.normalize();

  return new Ray(origin, direction);
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading