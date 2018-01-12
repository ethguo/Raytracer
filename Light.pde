abstract class Light {
  Vector3 colour;

  abstract Vector3 getDirection(Vector3 point);
  abstract float getIntensity(Vector3 point);
}