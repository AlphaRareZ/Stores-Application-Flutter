import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

class DistanceMapWidget extends StatefulWidget {
  final LatLng destinationPosition;
  DistanceMapWidget({required this.destinationPosition});

  @override
  _DistanceMapWidgetState createState() => _DistanceMapWidgetState();
}

class _DistanceMapWidgetState extends State<DistanceMapWidget> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  PolylinePoints _polylinePoints = PolylinePoints();
  final List<LatLng> _polylineCoordinates = [];
  // LatLng _currentPosition = LatLng(30.0417802, 31.0626649);

  String _distance = '0.0';

  void _addMarkersAndCalculateDistance() async {
    final currentPosition = await _getLocation();
    print("Current Position ==> : $currentPosition");
    // print("Destination Position ==> : ${widget.destinationPosition}");
    // final currentPosition = LatLng(30.0417802,31.0626649); // working
    // final currentPosition = LatLng(37.4219983, -122.084); // my real current location (not working!)

    _markers.add(
      Marker(
        markerId: const MarkerId('CurrentLocation'),
        position: currentPosition,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('Destination'),
        // position: widget.destinationPosition,
        position: widget.destinationPosition,
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );

    _calculateDistance(currentPosition, widget.destinationPosition);
  }

  Future<LatLng> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true);
    return LatLng(position.latitude, position.longitude);
  }

  void _calculateDistance(LatLng position1, LatLng position2) async {
    _polylineCoordinates.clear();
    try {
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCCxKNAaHITh3Hm-DvbQDc21k-TcwOiQ8w',
        PointLatLng(position1.latitude, position1.longitude),
        PointLatLng(position2.latitude, position2.longitude),
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        setState(() {
          print("New Calculated Distance: ${result.distance}");
          var distance =
              (double.parse(result.distance!.split(" ")[0]) * 1.60934);
          _distance = distance.toStringAsFixed(2);
        });
      } else {
        print("No points found in route.");
      }
    } catch (e) {
      if (e.toString().contains("ZERO_RESULTS")) {
        // If no route is found between the two points
        // just calculate the straight line distance
        double distanceInMeters = Geolocator.distanceBetween(
          position1.latitude,
          position1.longitude,
          position2.latitude,
          position2.longitude,
        );
        setState(() {
          _distance = (distanceInMeters / 1000).toStringAsFixed(2);
        });
        print("the current location is $position1");
        print("the destination location is $position2");
        print("No route found between the specified coordinates.");
      } else {
        print("Error: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
    _addMarkersAndCalculateDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.destinationPosition, // Initial map position
          zoom: 12,
        ),
        markers: _markers,
        polylines: {
          Polyline(
            polylineId: const PolylineId('Polyline'),
            color: Colors.blue,
            points: _polylineCoordinates,
            width: 5,
          ),
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.white,
        child: Text('Distance: $_distance km'),
      ),
    );
  }
}
