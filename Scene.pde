class Scene extends JSONSerializable {
  public float fov;
  public Vector3 origin;
  public Vector3 skyColor;
  public float shadowBias;
  public SceneObject[] sceneObjects;
  public Light[] lights;

  Scene() {
    this.fov = 75;
    this.origin = new Vector3(0, 0, 0);
    this.skyColor = new Vector3(#8CBED6);
    this.shadowBias = 1e-4;

    this.sceneObjects = new SceneObject[] {
      new Sphere(new Vector3(0, -1, -4), 1, 0.9),
      new Sphere(new Vector3(1, 0, -7), 2, 0.8),
      new Sphere(new Vector3(-1, 1.5, -5), 0.33, 0.9),
      new Plane(new Vector3(0, -2, 0), new Vector3(0, 1, 0), 0.6)
    };

    this.lights = new Light[] {
      new DirectionalLight(new Vector3(0, -1, 0), #CCCCCC, 1),
      new DirectionalLight(new Vector3(1, -1, -1), #FFCC99, PI),
      new DirectionalLight(new Vector3(-1, -0.5, -0.5), #3399FF, 1.5),
    };
  }

  Scene(JSONObject j) {
    super(j);
    // this.direction = new Vector3(j.getJSONObject("direction"));
    // this.intensity = j.getFloat("intensity");
  }

  // JSONObject toJSONObject() {
    // JSONObject j = super.toJSONObject();
    // j.setFloat("fov", this.fov);
    // return j;
  // }
}