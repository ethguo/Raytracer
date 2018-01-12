int imageWidth = 400;
int imageHeight = 400;
float fov = 75;
Vector3 origin = new Vector3(0, 0, 0);
color skyColor = #8CBED6;

float imagePixelWidth;
float imagePixelHeight;

SceneObject[] sceneObjects = new SceneObject[] {
  new Sphere(new Vector3(0, -0.5, -3), 1, 0.9),
  new Sphere(new Vector3(1, 0.5, -4), 1, 0.9),
  new Sphere(new Vector3(-1, 0, -2), 0.25, 0.9)
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

      RayCastHit hit = castRay(primaryRay);
      if (hit != null) {
        Vector3 pointShading = getPointShading(hit);
        fill(pointShading.toColor());
        rect(imageX * imagePixelWidth, imageY * imagePixelHeight, imagePixelWidth, imagePixelHeight);
      }
    }
  }

  int elapsedTime = millis() - t0;
  println(elapsedTime);

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

RayCastHit castRay(Ray ray) {
  float tMin = Float.POSITIVE_INFINITY;
  SceneObject hitObject = null;
  for (SceneObject sceneObject : sceneObjects) {
    float tHit = sceneObject.rayIntersect(ray);
    if (tHit != 0 && tHit < tMin) {
      tMin = tHit;
      hitObject = sceneObject;
    }
  }

  if (hitObject == null)
    return null;

  Vector3 hitPoint = ray.solve(tMin);
  RayCastHit hit = new RayCastHit(hitObject, tMin, hitPoint);
  return hit;
}


Vector3 getPointShading(RayCastHit hit) {
  Vector3 normal = hit.sceneObject.getNormal(hit.point);

  // Facing Ratio shading method
  // hit.colour = max(0, -ray.direction.dot(normal)) * 255;

  Vector3 pointShading = new Vector3();

  for (Light light : lights) {
    float lightIntensity = light.getIntensity(hit.point);
    Vector3 lightDirection = light.getDirection(hit.point);

    float intensity = lightIntensity
                    * hit.sceneObject.albedo / PI
                    * max(0, -normal.dot(lightDirection));

    pointShading = pointShading.plus(light.colour.times(intensity));
  }
  return pointShading;
}

// Next: https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/ligth-and-shadows