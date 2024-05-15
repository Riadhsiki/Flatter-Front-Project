import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);
  @override
  _MapSampleState createState() => _MapSampleState();
}
class _MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;
  Location location = Location();
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  Future<void> _getUserLocation() async {
    try {
      LocationData userLocation = await location.getLocation();
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(userLocation.latitude!, userLocation.longitude!),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      print("Error getting user location: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Container(
        height: 320,
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(36.8453526, 10.1605068),
            zoom: 10,
          ),
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              mapController = controller;
            });
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}