import 'dart:math';

import 'package:green_route/buttons/floating_searchbar.dart';
import 'package:green_route/helpers/helpermethods.dart';
import 'package:green_route/helpers/path_matcher.dart';
import 'package:green_route/screens/ambulace_map.dart';
import 'package:green_route/screens/ambulance_signup.dart';
import 'package:flutter/material.dart';
import 'package:green_route/buttons/round_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_route/services/push_notification.dart';
import 'package:permission/permission.dart';
import 'dart:async';
import 'package:green_route/services/Node_identify.dart';
import 'package:provider/provider.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/services/database.dart';
import 'package:green_route/services/location.dart';
import 'package:green_route/services/push_notification.dart';

double latitude = 19.079790;
double longitude = 72.904050;

class MainMap extends StatefulWidget {
  static String id = 'main_map';
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  Future<String> notificationCall() async {
    PushNotificationsManager pushNotificationService =
        PushNotificationsManager();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User usert = auth.currentUser;
    final uid = usert.uid;

    String token = await pushNotificationService.init();
    DatabaseService(uid: uid).updateUserToken(token);

    return token;
  }

  void initState() {
    super.initState();
    getCurrentLocation();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    DatabaseService(uid: uid).updateUserData(false, latitude, longitude);

    notificationCall();
  }

  void getCurrentLocation() async {
    GetLocation location = GetLocation();
    await location.getLocation();
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });
  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  double mapBottomPadding = 0;

  Position currentPosition;
  var geolocator = Geolocator();

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    String address = await HelperMethods.findCordinateAddress(position);
    print(address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  static final CameraPosition _currentpos = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(latitude, longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      key: _drawerKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              setupPositionLocator();
            },
          ),
          floatingSearchBar(
            onPressed: () => _drawerKey.currentState.openEndDrawer(),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 30,
            left: 17,
            child: RoundButton(
              btn_color: Colors.blue,
              onPressed: () {},
              btn_icon: Icon(
                Icons.directions,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 100,
            left: 17,
            child: RoundButton(
              btn_color: Colors.white,
              onPressed: () {
                setupPositionLocator();
              },
              btn_icon: Icon(
                Icons.gps_fixed,
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int Index) {}, // new
        currentIndex: 0, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            title: Text('Explore'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.house),
            title: Text('Commute'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), title: Text('Saved')),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_hospital_rounded,
                color: Colors.red,
              ),
              title: Text('For Ambulance'),
              onTap: () {
                Navigator.pushNamed(context, AmbulanceSignUp.id);
              },
            ),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Logout'),
                onTap: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                }),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                List pt_1 = [
                  (pi / 180) * (19.134061),
                  (pi / 180) * (72.910901)
                ];
                List pt_2 = [
                  (pi / 180) * (19.126275438939253),
                  (pi / 180) * (72.91820117092337)
                ];
                List user_pt = [
                  (pi / 180) * (19.127300),
                  (pi / 180) * (72.9220901)
                ];

                bool new_1 = pathMatching(pt_1[0], pt_2[0], user_pt[0]);
                bool new_2 = pathMatching(pt_1[1], pt_2[1], user_pt[1]);
                //print(new_1);
                if ((new_1) & (new_2)) {
                  print("yoohooo");
                } else {
                  print("oh noo");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('test'),
              onTap: () {
                return NodeIdentify();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _currentPos() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentpos));
  }
}
