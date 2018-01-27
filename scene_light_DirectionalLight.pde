class DirectionalLight extends Light {
  public Vector3 direction;
  public float intensity;


  DirectionalLight(Vector3 direction, color colour, float intensity) {
    super(colour);
    this.direction = direction.times(-1).normalize();
    this.intensity = intensity;
  }

  /**
   * Constructs a DirectionalLight object from the values in the JSONObject (JSON deserialization).
   * @param j the JSONObject containing the values for this object.
   */
  public DirectionalLight(JSONObject j) {
    super(j);
    this.direction = new Vector3(j.getJSONObject("direction")).times(-1).normalize();
    this.intensity = j.getFloat("intensity");
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setJSONObject("direction", this.direction.times(-1).toJSONObject());
    j.setFloat("intensity", this.intensity);
    return j;
  }

  Vector3 getIncidentDirection(Vector3 point) {
    return this.direction;
  }
  
  float getIntensity(Vector3 point) {
    return this.intensity;
  }

  float getDistance(Vector3 point) {
    return Float.POSITIVE_INFINITY;
  }

  // gui_Tweakable methods

  ArrayList<ParameterControl> getParameters() {
    ArrayList<ParameterControl> parameters = super.getParameters();
    parameters.add(0, new Vector3Parameter(this, "direction", "Direction", this.direction, -5, 5));
    parameters.add(1, new FloatParameter(this, "intensity", "Intensity", this.intensity, 0, 5));
    return parameters;
  }
}