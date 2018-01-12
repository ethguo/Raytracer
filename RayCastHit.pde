class RayCastHit {
  SceneObject hitObject;
  Vector3 colour;

  RayCastHit(SceneObject hitObject) {
    this.hitObject = hitObject;
    this.colour = new Vector3();
  }
}