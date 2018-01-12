class RayCastHit {
  SceneObject sceneObject;
  float t;
  Vector3 point;

  RayCastHit(SceneObject sceneObject, float t, Vector3 point) {
    this.sceneObject = sceneObject;
    this.t = t;
    this.point = point;
  }
}