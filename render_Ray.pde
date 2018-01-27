/**
 * Represents a ray that can be traced. After tracing, the hit data is stored in the same Ray object, so the shading at that point can be computed next if desired.
 */
class Ray {
  public Vector3 origin;
  public Vector3 direction;

  SceneObject hitObject;
  Vector3 hitPoint;
  float tHit;

  /**
   * Create a Ray given the origin point and direction vector.
   * @param origin    the origin point of the ray (point when t=0).
   * @param direction unit vector defining the direction of the ray.
   */
  Ray(Vector3 origin, Vector3 direction) {
    this(origin, direction, Float.POSITIVE_INFINITY);
  }

  /**
   * Create a Ray given the origin point and direction vector.
   * @param origin      the origin point of the ray (point when t=0).
   * @param direction   unit vector defining the direction of the ray.
   * @param maxDistance (optional) any hits beyond this distance will be ignored. Also known as the far clipping plane.
   */
  Ray(Vector3 origin, Vector3 direction, float maxDistance) {
    this.origin = origin;
    this.direction = direction.normalize();
    this.tHit = maxDistance;
  }

  /** Generates a human-friendly String representation of this Ray for debugging purposes. */
  String toString() {
    return this.origin.toString() + " + t" + this.direction.toString();
  }

  /**
   * Evaluates the equation of the line at t. Since direction is a unit vector,
   * this will return the point t units away from the ray's origin, in the direction of the direction vector.
   * @param  t  the distance from the ray's origin.
   * @return    a point t units away from the ray's origin, in the direction of the direction vector.
   */
  Vector3 getPoint(float t) {
    return this.origin.plus(this.direction.times(t));
  }

  /**
   * Determines the closest SceneObject that this ray intersects with.
   * The t value (distance to the camera), the SceneObject that was hit, and the hit point are stored in this Ray object,
   * for later use in getPointShading().
   * @param  scene  the Scene containing the SceneObjects to test for intersection.
   * @return        whether or not any object was hit.
   */
  boolean trace(Scene scene) {
    for (SceneObject sceneObject : scene.sceneObjects) {
      // Ask each SceneObject whether this ray intersects with it.
      float tHitObject = sceneObject.rayIntersect(this);
      if (tHitObject > 0 && tHitObject < this.tHit) {
        // If the hit distance is positive and does not exceed the max distance, store it.
        this.tHit = tHitObject;
        this.hitObject = sceneObject;
      }
    }

    if (this.hitObject != null) {
      // If an object was hit, get (and store) the point in 3D space where it was hit.
      this.hitPoint = this.getPoint(this.tHit);
      return true;
    }

    return false;
  }

  /**
   * Determines the color of the point that was hit by this ray.
   * @param  scene  the Scene containing the relevant data.
   * @return        vector representing the RGB color of the point.
   */
  Vector3 getPointShading(Scene scene) {
    Vector3 pointShading = new Vector3();
    Vector3 normal = this.hitObject.getNormal(this.hitPoint);

    for (Light light : scene.lights) {
      // Since DirectionalLight and PointLight are both subclasses of the Light class, we can process them in the same loop.
      // These getters will just behave differently depending on the specific type of light.
      float lightIntensity = light.getIntensity(this.hitPoint);
      float lightDistance = light.getDistance(this.hitPoint);
      Vector3 lightDirection = light.getDirection(this.hitPoint);

      Vector3 shadowRayOrigin = this.hitPoint.plus(normal.times(scene.shadowBias));

      // the maxDistance of the shadow ray is set to the distance to the light, to prevent the ray from "overshooting"
      // a directional light and hitting an object beyond the light, which would make it think that the point is in 
      // shadow when it isn't.
      Ray shadowRay = new Ray(shadowRayOrigin, lightDirection, lightDistance);
      boolean shadow = shadowRay.trace(scene);

      // If the point isn't in shadow, compute the contribution to the total brightness, and add it to pointShading.
      if (!shadow) {
        float intensity = lightIntensity / PI * max(0, normal.dot(lightDirection));
        Vector3 colour = light.colour.hadamardTimes(this.hitObject.albedo);

        pointShading = pointShading.plus(colour.times(intensity));
      }
    }
    return pointShading;
  }
}