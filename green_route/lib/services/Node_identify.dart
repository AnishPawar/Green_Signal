import 'package:green_route/models/ambulance_class.dart';
import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/main_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:green_route/services/AmbulanceRoute.dart';

class NodeIdentify extends StatelessWidget {
  List userList = [];
  static String id = 'Node_identify';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection("User_Database").get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot documents = snapshot.data;
              List<DocumentSnapshot> docs = documents.docs;
              docs.forEach((data) {
                if (!data['Ambulance']) {
                  userList.add([
                    data.id,
                    data["Current_Latitude"],
                    data["Current_Longitude"]
                  ]);
                  print("this");
                }
              });
            }

            if (userList.length != 0) {
              print("that");
              Ambulance_Model(userLocations: userList).printLocations();
            }
            // Navigator.pop(context);
            //Navigator.of(context).pop();
            return AmbulanceMap();
          }),
    );
  }
}
