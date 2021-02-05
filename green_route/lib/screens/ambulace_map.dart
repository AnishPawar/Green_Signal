import 'package:green_route/buttons/floating_searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_route/services/Node_identify.dart';
import 'package:green_route/widgets/globalvariable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:green_route/buttons/round_button.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:green_route/screens/ambulance_signup.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:green_route/services/location.dart';
import '../buttons/round_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_route/helpers/helpermethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/services/database.dart';

double latitude = 19.079790;
double longitude = 72.904050;

class AmbulanceMap extends StatefulWidget {
  static String id = 'ambulance_map';
  @override
  _AmbulanceMapState createState() => _AmbulanceMapState();
}

class _AmbulanceMapState extends State<AmbulanceMap> {
  void initState() {
    super.initState();
    getCurrentLocation();

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    DatabaseService(uid: uid).updateUserData(true, latitude, longitude);
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
    zoom: 19.151926040649414,
  );

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Create a Green Corridor?'),
          content: Text(
              'A faster route will be created for Ambulance. Use only in case of Emergency!'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //Navigator.of(context).pop();
                // final FirebaseAuth auth = FirebaseAuth.instance;
                // final User usert = auth.currentUser;
                // final uid = usert.uid;
                // DatabaseService(uid: uid)
                //     .updateAmbulanceData(latitude, longitude, [
                //   {"Latitude": 19.07979, "Longitude": 72.90551},
                //   {"Latitude": 19.17979, "Longitude": 72.91551}
                // ], []);
                // return NodeIdentify();
                Navigator.pushNamed(context, NodeIdentify.id);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'No',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
              btn_color: Colors.white,
              onPressed: () {
                _handleClickMe();
              },
              btn_icon: Icon(
                Icons.local_hospital_outlined,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 95,
            left: 17,
            child: RoundButton(
              btn_color: Colors.blue,
              onPressed: () {},
              btn_icon: Icon(
                Icons.drive_eta,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 160,
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
