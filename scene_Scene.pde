class Scene extends JSONSerializable {
  public float fov;
  public float shadowBias;
  public Vector3 cameraOrigin;
  public Vector3 skyColor;
  public ArrayList<SceneObject> sceneObjects;
  public ArrayList<Light> lights;

  Scene() {
    this.fov = 75;
    this.shadowBias = 1e-4;
    this.cameraOrigin = new Vector3(0, 0, 0);
    this.skyColor = new Vector3(#8CBED6);

    this.sceneObjects = new ArrayList<SceneObject>();
    this.sceneObjects.add(new Sphere(new Vector3(0, -1, -4), 1, 0.9));
    this.sceneObjects.add(new Sphere(new Vector3(1, 0, -7), 2, 0.8));
    this.sceneObjects.add(new Sphere(new Vector3(-1, 1.5, -5), 0.33, 0.9));
    this.sceneObjects.add(new Plane(new Vector3(0, -2, 0), new Vector3(0, 1, 0), 0.6));

    this.lights = new ArrayList<Light>();
    this.lights.add(new DirectionalLight(new Vector3(0, -1, 0), #CCCCCC, 1));
    this.lights.add(new DirectionalLight(new Vector3(1, -1, -1), #FFCC99, PI));
    this.lights.add(new DirectionalLight(new Vector3(-1, -0.5, -0.5), #3399FF, 1.5));
  }

  public Scene(JSONObject j) {
    super(j);
    this.fov = j.getFloat("fov");
    this.shadowBias = j.getFloat("shadowBias");
    this.cameraOrigin = new Vector3(j.getJSONObject("cameraOrigin"));
    this.skyColor = new Color(j.getJSONObject("skyColor")).toVector3();
    this.sceneObjects = fromJSONArray(j.getJSONArray("sceneObjects"));
    this.lights = fromJSONArray(j.getJSONArray("lights"));
  }

  JSONObject toJSONObject() {
    JSONObject j = super.toJSONObject();
    j.setFloat("fov", this.fov);
    j.setFloat("shadowBias", this.shadowBias);
    j.setJSONObject("cameraOrigin", this.cameraOrigin.toJSONObject());
    j.setJSONObject("skyColor", new Color(this.skyColor).toJSONObject());
    j.setJSONArray("sceneObjects", toJSONArray(this.sceneObjects));
    j.setJSONArray("lights", toJSONArray(this.lights));
    return j;
  }

  // Deep copies this object, by serializing it then deserializing it again.
  Scene copy() {
    return new Scene(this.toJSONObject());
  }
}