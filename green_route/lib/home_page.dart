import 'package:green_route/screens/main_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/database.dart';
import 'services/BishList.dart';
import 'package:green_route/services/Node_identify.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_route/screens/login_page.dart';
import 'package:green_route/screens/ambulance_signup.dart';
import 'package:provider/provider.dart';

var userPhotos;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return BishList();
                // return NodeIdentify();
                // return MainMap();
              } else {
                return SignUpPage();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      );
}
