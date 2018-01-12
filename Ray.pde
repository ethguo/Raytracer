class Ray {
  Vector3 origin;
  Vector3 direction;

  SceneObject hitObject;
  Vector3 hitPoint;
  float tHit;

  Ray(Vector3 origin, Vector3 direction) {
    this.origin = origin;
    this.direction = direction;
  }

  String toString() {
    return this.origin.toString() + " + t" + this.direction.toString();
  }

  Vector3 solve(float t) {
    return this.origin.plus(this.direction.times(t));
  }

  boolean cast() {
    this.tHit = Float.POSITIVE_INFINITY;
    for (SceneObject sceneObject : sceneObjects) {
      float tHitObject = sceneObject.rayIntersect(this);
      if (tHitObject > 0 && tHitObject < this.tHit) {
        this.tHit = tHitObject;
        this.hitObject = sceneObject;
      }
    }

    if (this.hitObject == null)
      return false;

    this.hitPoint = this.solve(this.tHit);
    return true;
  }

  Vector3 getPointShading() {
    Vector3 normal = this.hitObject.getNormal(this.hitPoint);

    // Facing Ratio shading method
    // hit.colour = max(0, -ray.direction.dot(normal)) * 255;

    Vector3 pointShading = new Vector3();

    for (Light light : lights) {
      float lightIntensity = light.getIntensity(this.hitPoint);
      Vector3 lightDirection = light.getDirection(this.hitPoint);
      Vector3 negLightDirection = lightDirection.times(-1);

      Ray shadowRay = new Ray(this.hitPoint.plus(normal.times(shadowBias)), negLightDirection);
      boolean shadow = shadowRay.cast();
      if (!shadow) {
        float intensity = lightIntensity
                        * this.hitObject.albedo / PI
                        * max(0, normal.dot(negLightDirection));

        pointShading = pointShading.plus(light.colour.times(intensity));
      }
    }
    return pointShading;
  }
}
