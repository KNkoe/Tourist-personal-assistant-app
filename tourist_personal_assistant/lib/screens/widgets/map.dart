import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tourist_personal_assistant/models/destination.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tourist_personal_assistant/screens/widgets/secrets.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key, required this.destination});

  final Destination destination;

  @override
  State<MyMap> createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  final Completer<GoogleMapController> _mapController = Completer();
  bool _getDirectionsIsPressed = false;

  Position? _currentPosition;
  List<Location> locations = [];

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  final CameraPosition _initialLocation =
      const CameraPosition(target: LatLng(0.0, 0.0));

  _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _addMarker(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          "origin",
          BitmapDescriptor.defaultMarker);
      debugPrint("CURRENT POSITION${_currentPosition!.latitude}");
    }
  }

  _getLocationCoordinates() async {
    locations = await locationFromAddress(
        "${widget.destination.title} ${widget.destination.tag}, Lesotho");

    setState(() {});

    final GoogleMapController controller = await _mapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(locations.first.latitude, locations.first.longitude),
        zoom: 14)));

    _addMarker(LatLng(locations.first.latitude, locations.first.longitude),
        "destination", BitmapDescriptor.defaultMarker);
    debugPrint("COORDINATES FROM ADDRESS${locations.first.toString()}");
  }

  _zoomInTilt() async {
    if (locations.isNotEmpty) {
      final GoogleMapController controller = await _mapController.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 192,
          target: LatLng(locations.first.latitude, locations.first.longitude),
          tilt: 59,
          zoom: 19)));
    }
  }

  _zoomOutTilt() async {
    if (locations.isNotEmpty) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locations.first.latitude, locations.first.longitude),
          zoom: 14)));
    }
  }

  _zoomIn() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  _zoomOut() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    _getLocationCoordinates();
  }

  Future _getPolylines() async {
    setState(() {
      _getDirectionsIsPressed = true;
    });

    if (locations.isNotEmpty) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locations.first.latitude, locations.first.longitude),
          zoom: 8)));
    }

    if (_currentPosition != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          Secrets.API_KEY,
          PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          PointLatLng(locations.first.latitude, locations.first.longitude),
          travelMode: TravelMode.driving,
          wayPoints: [
            PolylineWayPoint(
                location:
                    "${widget.destination.title} ${widget.destination.tag}, Lesotho")
          ]);
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      _addPolyLine();

      debugPrint(result.status);
    }
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        title: Text(
          widget.destination.title!.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white60),
                  onPressed: () {
                    _zoomOutTilt();
                  },
                  child: const Icon(
                    Icons.zoom_out_map,
                    color: Colors.black54,
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white60),
                  onPressed: () {
                    _zoomInTilt();
                  },
                  child: const Icon(
                    Icons.zoom_in_map,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            (_getDirectionsIsPressed)
                ? const CircularProgressIndicator()
                : FloatingActionButton.extended(
                    onPressed: () {
                      _getPolylines().then((value) => setState(
                            () => _getDirectionsIsPressed = false,
                          ));
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text("Get Directions"),
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white60),
                  onPressed: () {
                    _zoomOut();
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black54,
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white60),
                  onPressed: () {
                    _zoomIn();
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
