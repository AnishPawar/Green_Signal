import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_route/helpers/path_matcher.dart';
import 'package:green_route/services/BishList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/services/database.dart';
import 'dart:convert';

class Ambulance_Model {
  Ambulance_Model({this.userLocations, this.amb_latitude, this.amb_longitude});
  List userLocations;
  double amb_latitude;
  double amb_longitude;
  void printLocations() {
    print(userLocations);
    getData();
  }

  Future<List> getData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;

    // var new_val = await FirebaseFirestore.instance
    //     .collection("Active_Ambulance")
    //     .doc(uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   List firestoreVal = documentSnapshot.data()['Path_Points'];
    //   double amb_latitude = documentSnapshot.data()['Ambulance_Latitude'];
    //   double amb_longitude = documentSnapshot.data()['Ambulance_Longitude'];
    //   List child_nodes = documentSnapshot.data()['Child_Nodes'];
    //   return [firestoreVal, amb_latitude, amb_longitude, child_nodes];
    // });

    int counter = 0;
    final jsonList = userLocations.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    bool pathCheck = false;

    List pathPoints = [
      {"Latitude": 19.07979, "Longitude": 72.90551},
      {"Latitude": 19.17979, "Longitude": 72.91551}
    ];

    List tempChildNodes = [];
    print(result);
    print(result.length);
    for (var i = 0; i < result.length; i++) {
      counter += 1;
      for (var j = 0; j < pathPoints.length - 1; j++) {
        print(j);
        pathCheck = preprocess(
            [pathPoints[j]["Latitude"], pathPoints[j]["Longitude"]],
            [pathPoints[j + 1]["Latitude"], pathPoints[j + 1]["Longitude"]],
            [result[i][1], result[i][2]]);
      }
      print("Is the user in path? $pathCheck of $counter");
      if (pathCheck) {
        tempChildNodes.add(result[i][0]);
      }
    }
    DatabaseService(uid: uid)
        .updateAmbulanceData(0.0000, 0.0000, pathPoints, tempChildNodes);
  }
}
