import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students_kyc_app/models/user.model.dart';
import 'package:students_kyc_app/pages/places.dart';

import '../widgets/mainDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user, required this.imagepath})
      : super(key: key);
  final Account user;
  final String imagepath;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  // ignore: unnecessary_const
  static const CameraPosition kenya = const CameraPosition(
    target: LatLng(1.286389, 36.817223),
    zoom: 19,
  );

  late Position currentPosition;
  var geoLocator = Geolocator();
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  bool newNotification = false;
  //   location pin
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: mainDrawer(context, widget.user, widget.imagepath),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        title: GestureDetector(
          onTap: () {},
          child: const Text(
            "WELCOME TO JKUAT",
            style: TextStyle(color: Colors.black),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 1.5,
              color: Colors.green),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        initialCameraPosition: kenya,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        markers: markersSet,
        circles: circlesSet,
        onMapCreated: (GoogleMapController controler) {
          controllerGoogleMap.complete(controler);
          newGoogleMapController = controler;
          setState(() {});
          locatePosition();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_outdoor),
            label: 'Outdoor',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlacesPage(),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: widget.user,
                  imagepath: widget.imagepath,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void locatePosition() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    if (kDebugMode) {
      print(statuses[Permission.location]);
    }
    if (statuses[Permission.location]!.isDenied) {
      requestPermission(Permission.location);
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;

      setState(() {
        markersSet.add(
          Marker(
              markerId: const MarkerId("user"),
              position: LatLng(position.latitude, position.longitude),
              anchor: const Offset(0.5, 0.5),
              draggable: false,
              flat: true,
              infoWindow: const InfoWindow(
                  title: "Home Address", snippet: "Current Location"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen)),
        );
      });

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 19);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  Future<void> requestPermission(Permission permission) async {
    await permission.request();
  }
}
