import 'dart:math';

int counter = 15;

bool pathMatching(List start_coord, List end_coord, List user_coord) {
  print("Going In");
  List averageAngle = [0, 0];
  for (var i = 0; i < 2; i += 1) {
    double x = 0;
    double y = 0;

    for (dynamic a in [
      [start_coord[i], end_coord[i]]
    ]) {
      x += cos(a);
      y += sin(a);
    }

    averageAngle[i] = atan2(y, x);
  }
  counter--;

  if ((((user_coord[0] - start_coord[0]).abs <= 0.0001) &
          ((user_coord[0] - end_coord[0]).abs <= 0.0001)) |
      (((user_coord[1] - start_coord[1]).abs <= 0.0001) &
          ((user_coord[1] - end_coord[1]).abs <= 0.0001))) {
    return true;
  }

  if (counter == 0) {
    return false;
  }

  if (((user_coord[0]) <= averageAngle[0]) &
      ((user_coord[1]) <= averageAngle[1])) {
    return pathMatching(start_coord, averageAngle, user_coord);
  }
  return pathMatching(averageAngle, end_coord, user_coord);
}
