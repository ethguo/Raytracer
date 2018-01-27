class PointLight extends Light {
  public Vector3 position;
  public float intensity;

  PointLight(Vector3 position, color colour, float intensity) {
    super(colour);
    this.position = position;
    this.intensity = intensity;
  }

  public PointLight(JSONObject j) {
    super(j);
    this.position = new Vector3(j.getJSONObject("position"));
    this.intensity = j.getFloat("intensity");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("position", this.position.toJSONObject());
    j.setFloat("intensity", this.intensity);
    return j;
  }

  Vector3 getIncidentDirection(Vector3 point) {
    return this.position.minus(point).normalize();
  }

  float getIntensity(Vector3 point) {
    float distance = this.position.minus(point).getMagnitudeSquared();
    return this.intensity / (4 * PI * distance);
  }

  float getDistance(Vector3 point) {
    return this.position.minus(point).getMagnitude();
  }

  // gui_Tweakable methods

  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = super.getParameters();
    parameters.add(0, new Vector3Parameter(this, "position", "Position", this.position, -5, 5));
    parameters.add(1, new FloatParameter(this, "intensity", "Intensity", this.intensity, 0, 4000));
    return parameters;
  }
}