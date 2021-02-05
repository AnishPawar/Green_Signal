import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/main_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;
// final User user = auth.currentUser;
// final uid = user.uid;

// class BishList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Active_Ambulance')
//             .doc(uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return new CircularProgressIndicator();
//           }
//           var document = snapshot.data;
//           List path_points = document["Path_Points"];
//           return (document["Path_Points"] ? AmbulanceMap() : MainMap());
//         },
//       ),
//     );
//   }
// }

// List Returnpath(String uid) {
//   StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Active_Ambulance')
//             .doc(uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return new CircularProgressIndicator();
//           }
//           var document = snapshot.data;
//           List path_points = document["Path_Points"];
//           return path_points;
//         },
//       ),
// }

// class ActiveAmbulance extends StatefulWidget {
//   @override
//   _ActiveAmbulanceState createState() => _ActiveAmbulanceState();
// }

// class _ActiveAmbulanceState extends State<ActiveAmbulance> {
//   dynamic data;

//   Future<dynamic> getData() async {

//     final DocumentReference document =  FirebaseFirestore.instance.collection("Active_Ambulance").doc(uid);

//     await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
//      setState(() {
//        data =snapshot.data;
//      });
//     });
//  }
// }
// class Lookout {
//   final String uid;
//   Lookout({this.uid});
Future<bool> getData(String uid) async {
  bool new_val = await FirebaseFirestore.instance
      .collection("User_Database")
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    bool firestoreVal = documentSnapshot.data()['Ambulance'];
    print("Return bool is: $firestoreVal");
    return firestoreVal;
  });
  return new_val;
}
// }
