Vector2 solveQuadratic(float a, float b, float c) {
  float discr = b*b - 4*a*c;
  if (discr < 0)
    return null;
  else {
    float x0, x1;
    if (discr == 0) {
      x0 = x1 = -b / (2*a);
    }
    else {
      float q;
      if (b > 0)
        q = (-b - sqrt(discr)) / 2;
      else
        q = (-b + sqrt(discr)) / 2;
      x0 = q / a;
      x1 = c / q;
    }
    return new Vector2(min(x0, x1), max(x0, x1));
  }
}