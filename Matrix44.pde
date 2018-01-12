// class Matrix44 {
//   float[][] matrix;

//   Matrix44() {
//     this.matrix = new float[][] {{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1}};
//   }

//   Matrix44 multiply(Matrix44 other) {
//     Matrix44 product = new Matrix44();
//     for (int i = 0; i < 4; i++)
//       for (int j = 0; j < 4; j++)
//         product.matrix[i][j] = this.matrix[i][0] * other.matrix[0][j]
//                              + this.matrix[i][1] * other.matrix[1][j]
//                              + this.matrix[i][2] * other.matrix[2][j]
//                              + this.matrix[i][3] * other.matrix[3][j];
//     return product;
//   }

//   Vector3 multiplyPoint(Vector3 vector) {
//     Vector3 product = new Vector3();
//     product.x = vector.x * this.matrix[0][0] + vector.y * this.matrix[1][0] + vector.z * this.matrix[2][0] + this.matrix[3][0];
//     product.y = vector.x * this.matrix[0][1] + vector.y * this.matrix[1][1] + vector.z * this.matrix[2][1] + this.matrix[3][1];
//     product.z = vector.x * this.matrix[0][2] + vector.y * this.matrix[1][2] + vector.z * this.matrix[2][2] + this.matrix[3][2];
//     return product;
//   }

//   Vector3 multiplyProjective(Vector3 vector) {
//     Vector3 product = new Vector3();
//     float w = vector.x * this.matrix[0][3] + vector.y * this.matrix[1][3] + vector.z * this.matrix[2][3] + this.matrix[3][3];
//     if (w == 0)
//       w = 1;
//     product.x = (vector.x * this.matrix[0][0] + vector.y * this.matrix[1][0] + vector.z * this.matrix[2][0] + this.matrix[3][0]) / w;
//     product.y = (vector.x * this.matrix[0][1] + vector.y * this.matrix[1][1] + vector.z * this.matrix[2][1] + this.matrix[3][1]) / w;
//     product.z = (vector.x * this.matrix[0][2] + vector.y * this.matrix[1][2] + vector.z * this.matrix[2][2] + this.matrix[3][2]) / w;
//     return product;
//   }

//   Vector3 multiplyVector(Vector3 vector) {
//     Vector3 product = new Vector3();
//     product.x = vector.x * this.matrix[0][0] + vector.y * this.matrix[1][0] + vector.z * this.matrix[2][0];
//     product.y = vector.x * this.matrix[0][1] + vector.y * this.matrix[1][1] + vector.z * this.matrix[2][1];
//     product.z = vector.x * this.matrix[0][2] + vector.y * this.matrix[1][2] + vector.z * this.matrix[2][2];
//     return product;
//   }

//   Vector3 multiplyNormal(Vector3 vector) {
//     println("WARNING: Matrix multiplication for normal vectors not properly implemented for non-uniform scaling");
//     // https://www.scratchapixel.com/lessons/mathematics-physics-for-computer-graphics/geometry/transforming-normals
//     Vector3 product = new Vector3();
//     product.x = vector.x * this.matrix[0][0] + vector.y * this.matrix[1][0] + vector.z * this.matrix[2][0];
//     product.y = vector.x * this.matrix[0][1] + vector.y * this.matrix[1][1] + vector.z * this.matrix[2][1];
//     product.z = vector.x * this.matrix[0][2] + vector.y * this.matrix[1][2] + vector.z * this.matrix[2][2];
//     return product;
//   }
// }