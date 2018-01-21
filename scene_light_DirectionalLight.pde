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
    this.direction = new Vector3(j.getJSONObject("direction")).normalize();
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

  // gui_Tweakable methods

  Parameter[] getParameters() {
    return new Parameter[] {
      new Vector3Parameter(this, "direction", "Direction", this.direction, -5, 5),
      new FloatParameter(this, "intensity", "Intensity", this.intensity, 0, 5)
    };
  }
}