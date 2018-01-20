class DirectionalLight extends Light {
  public Vector3 direction;
  public float intensity;

  DirectionalLight(Vector3 direction, color colour, float intensity) {
    super(colour);
    this.direction = direction.normalize();
    this.intensity = intensity;
  }

  public DirectionalLight(JSONObject j) {
    super(j);
    this.direction = new Vector3(j.getJSONObject("direction"));
    this.intensity = j.getFloat("intensity");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("direction", this.direction.toJSONObject());
    j.setFloat("intensity", this.intensity);
    return j;
  }

  Vector3 getDirection(Vector3 point) {
    return this.direction;
  }
  float getIntensity(Vector3 point) {
    return this.intensity;
  }

}