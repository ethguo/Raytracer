class DirectionalLight extends Light {
  Vector3 direction;
  float intensity;

  DirectionalLight(Vector3 direction, color colour, float intensity) {
    this.direction = direction;
    this.intensity = intensity;
    this.colour = new Vector3(colour);
  }

  Vector3 getDirection(Vector3 point) {
    return this.direction;
  }
  float getIntensity(Vector3 point) {
    return this.intensity;
  }
}