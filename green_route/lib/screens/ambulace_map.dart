<<<<<<< HEAD
import 'package:flutter_animarker/lat_lng_interpolation.dart';
import 'package:flutter_animarker/models/lat_lng_delta.dart';
import 'package:green_route/buttons/floating_searchbar.dart';
=======
import 'dart:io';

>>>>>>> main
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_route/services/BishList.dart';
import 'package:green_route/buttons/round_button.dart';
import 'package:green_route/provider/google_signin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import '../buttons/round_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_route/helpers/helpermethods.dart';
import 'package:green_route/screens/search_page.dart';
import 'package:green_route/widgets/ProgessDialog.dart';
import 'package:green_route/dataprovider/appdata.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_route/services/database.dart';
import 'package:green_route/services/Node_identify.dart';
import 'package:green_route/models/ambulance_class.dart';

double latitude = 19.079790;
double longitude = 72.904050;

class AmbulanceMap extends StatefulWidget {
  static String id = 'ambulance_map';
  @override
  _AmbulanceMapState createState() => _AmbulanceMapState();
}

// final startPosition = LatLng(18.488213, -69.959186);

// //Run over the polygon position
// final polygon = <LatLng>[
//   startPosition,
//   LatLng(18.489338, -69.947091),
//   LatLng(18.495351, -69.949366),
//   LatLng(18.497477, -69.947596),
//   LatLng(18.498932, -69.948615),
//   LatLng(18.498373, -69.958779),
//   LatLng(18.488600, -69.959574),
// ];

class _AmbulanceMapState extends State<AmbulanceMap> {
  int i = 0;
  void initState() {
    super.initState();
    // getCurrentLocation();
<<<<<<< HEAD
=======
    setCustomMarker();
>>>>>>> main

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
<<<<<<< HEAD
    DatabaseService(uid: uid).updateUserData(true, latitude, longitude);

    // subscription =
    //     _latLngStream.getLatLngInterpolation().listen((LatLngDelta delta) {
    //   LatLng from = delta.from;
    //   print("To: -> ${from.toJson()}");
    //   LatLng to = delta.to;
    //   print("From: -> ${to.toJson()}");
    //   double angle = delta.rotation;
    //   print("Angle: -> $angle");
    //   //Update the animated marker
    //   setState(() {
    //     Marker sourceMarker = Marker(
    //       markerId: sourceId,
    //       rotation: delta.rotation,
    //       position: LatLng(
    //         delta.from.latitude,
    //         delta.from.longitude,
    //       ),
    //     );
    //     _markers[sourceId] = sourceMarker;
    //   });

    //   if (polygon.isNotEmpty) {
    //     //Pop the last position
    //     _latLngStream.addLatLng(polygon.removeLast());
    //   }
    // });

    // super.initState();
  }
=======
    DatabaseService(uid: uid).updateUserData(true, latitude, longitude, '');
>>>>>>> main

    // Navigator.of(context).pop();
  }

  // void getCurrentLocation() async {
  //   GetLocation location = GetLocation();
  //   await location.getLocation();
  //   setState(() {
  //     latitude = location.latitude;
  //     longitude = location.longitude;
  //   });
  // }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  double mapBottomPadding = 0;

<<<<<<< HEAD
  LatLngInterpolationStream _latLngStream =
      LatLngInterpolationStream(movementDuration: Duration(seconds: 5));
  StreamSubscription<LatLngDelta> subscription;
=======
  BitmapDescriptor mapMarker;
>>>>>>> main

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  Position currentPosition;
  LatLng pos;
  var geolocator = Geolocator();
  LatLng pos;

  Future sleep() {
    return new Future.delayed(Duration(seconds: 1));
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/car_icon2.png');
  }

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

<<<<<<< HEAD
    pos = LatLng(position.latitude, position.longitude);
=======
    getLocationHelper(position);

    LatLng pos = LatLng(position.latitude, position.longitude);
>>>>>>> main
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    String address =
        await HelperMethods.findCordinateAddress(position, context);
    print(address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  // final CameraPosition _kSantoDomingo = CameraPosition(
  //   target: startPosition,
  //   zoom: 15,
  // );

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('Create a Green Corridor?'),
          content: Text(
              'A faster route will be created for Ambulance. Use only in case of Emergency!'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                // Navigator.pushNamed(context, NodeIdentify.id);
                streamReturn();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Colors.lightBlue, fontSize: 18),
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

  Future<void> popNotif() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('Ambulance is on the way'),
          content: Text('Please make way!!'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.red, fontSize: 18),
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

  // final Map<MarkerId, Marker> _markers = Map<MarkerId, Marker>();
  // MarkerId sourceId = MarkerId("SourcePin");

  // @override
  // void dispose() {
  //   subscription.cancel();
  //   super.dispose();
  // }

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
            // initialCameraPosition: _kGooglePlex,
            // markers: Set<Marker>.of(_markers.values),
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: _polylines,
            markers: _markers,
            circles: _circles,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              setupPositionLocator();

              // setState(() {
              //   Marker sourceMarker = Marker(
              //     markerId: sourceId,
              //     position: startPosition,
              //   );
              //   _markers[sourceId] = sourceMarker;
              // });

              // _latLngStream.addLatLng(startPosition);
              // //Add second position to start position over
              // Future.delayed(const Duration(milliseconds: 3000), () {
              //   _latLngStream.addLatLng(polygon.removeLast());
              // });
            },
          ),
          Column(
            children: [
              SizedBox(
                height: 55.0,
              ),
              GestureDetector(
                onTap: () async {
                  var response = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));

                  if (response == 'getDirection') {
                    await getDirection();
                  }
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                          size: 25.0,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Search..',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            width: 52,
            height: 52,
            top: 120,
            right: 20,
            child: RoundButton(
              btn_color: Colors.white,
              onPressed: () => _drawerKey.currentState.openEndDrawer(),
              btn_icon: Icon(
                Icons.menu,
                color: Colors.black,
                size: 23,
              ),
            ),
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 90,
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
            bottom: 25,
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
          ),
          Positioned(
            width: 60,
            height: 60,
            bottom: 100,
            right: 17,
            child: RoundButton(
              btn_color: Colors.black,
<<<<<<< HEAD
              onPressed: () {
                setState(() {
                  pos = polylineCoordinates[i];
                  i++;
                  print(pos);
                  print("I = $i");
                  Marker newCar = Marker(
                      markerId: MarkerId('bus'),
                      position: pos,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRose));
                  _markers.add(newCar);
                });
=======
              onPressed: () async {
                while (i < polylineCoordinates.length) {
                  setState(() {
                    if (i < polylineCoordinates.length) {
                      pos = polylineCoordinates[i];
                      i++;
                      print(pos);
                      print("I = $i");
                      Marker newCar1 = Marker(
                        markerId: MarkerId('bus3'),
                        position: pos,
                        icon: mapMarker,
                      );
                      _markers.add(newCar1);
                    }
                  });
                  double current_lat = pos.latitude;
                  double current_long = pos.longitude;
                  var new_val = await FirebaseFirestore.instance
                      .collection("Active_Ambulance")
                      .doc(uid)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    List pathPoints = documentSnapshot.data()['Path_Points'];
                    List child_nodes = documentSnapshot.data()['Child_Nodes'];
                    return [pathPoints, child_nodes];
                  });
                  DatabaseService(uid: uid).updateAmbulanceData(
                      current_lat, current_long, new_val[0], new_val[1]);
                  sleep();
                }
>>>>>>> main
              },
              btn_icon: Icon(
                Icons.brightness_1,
                color: Colors.white,
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

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait...',
      ),
    );

    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);
    getPathPoints(results);
    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });

    LatLngBounds bounds;

    if (pickup.latitude > destination.latitude &&
        pickup.longitude > destination.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickup.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude));
    } else if (pickup.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    // Marker pickupMarker = Marker(
    //   markerId: MarkerId('pickup'),
    //   position: pickLatLng,
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //   infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    // );

<<<<<<< HEAD
    // var carLatLng = LatLng(
    //     polylineCoordinates[i].latitude, polylineCoordinates[i].longitude);
    // print('Coordinates : $carLatLng');
    // print("Polyline Coordinates : $polylineCoordinates");
    setState(() {
      Marker car = Marker(
          markerId: MarkerId('car'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
      _markers.add(car);
    });

    // Marker destinationMarker = Marker(
    //   markerId: MarkerId('destination'),
    //   position: destinationLatLng,
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    //   infoWindow:
    //       InfoWindow(title: destination.placeName, snippet: 'Destination'),
    // );

    // setState(
    //   () {
    //     _markers.add(pickupMarker);
    //     _markers.add(destinationMarker);
    //   },
    // );
=======
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(
      () {
        // _markers.add(pickupMarker);
        _markers.add(destinationMarker);
        Marker car = Marker(
            markerId: MarkerId('car'),
            position: pos,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
        _markers.add(car);
      },
    );
>>>>>>> main

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.green,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purpleAccent,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Colors.purpleAccent,
    );

    setState(
      () {
        _circles.add(pickupCircle);
        _circles.add(destinationCircle);
      },
    );
  }
}
