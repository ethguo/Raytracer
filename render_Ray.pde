class Ray {
  Vector3 origin;
  Vector3 direction;

  SceneObject hitObject;
  Vector3 hitPoint;
  float tHit;

  Ray(Vector3 origin, Vector3 direction) {
    this(origin, direction, Float.POSITIVE_INFINITY);
  }

  Ray(Vector3 origin, Vector3 direction, float tMax) {
    this.origin = origin;
    this.direction = direction;
    this.tHit = tMax;
  }

  String toString() {
    return this.origin.toString() + " + t" + this.direction.toString();
  }

  Vector3 getPoint(float t) {
    return this.origin.plus(this.direction.times(t));
  }

  boolean trace(Scene scene) {
    for (SceneObject sceneObject : scene.sceneObjects) {
      float tHitObject = sceneObject.rayIntersect(this);
      if (tHitObject > 0 && tHitObject < this.tHit) {
        this.tHit = tHitObject;
        this.hitObject = sceneObject;
      }
    }

    if (this.hitObject == null)
      return false;

    this.hitPoint = this.getPoint(this.tHit);
    return true;
  }

  Vector3 getPointShading(Scene scene) {
    Vector3 normal = this.hitObject.getNormal(this.hitPoint);

    // Facing Ratio shading method
    // Vector3 pointShading = max(0, -ray.direction.dot(normal)) * 255;

    Vector3 pointShading = new Vector3();

    for (Light light : scene.lights) {
      float lightIntensity = light.getIntensity(this.hitPoint);
      float lightDistance = light.getDistance(this.hitPoint);
      Vector3 lightDirection = light.getIncidentDirection(this.hitPoint);

      Ray shadowRay = new Ray(this.hitPoint.plus(normal.times(scene.shadowBias)), lightDirection, lightDistance);
      boolean shadow = shadowRay.trace(scene);
      if (!shadow) {
        float intensity = lightIntensity / PI * max(0, normal.dot(lightDirection));
        Vector3 shading = light.colour.componentTimes(this.hitObject.albedo);

        pointShading = pointShading.plus(shading.times(intensity));
      }
    }
    return pointShading;
  }
}