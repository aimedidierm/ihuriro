import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:location/location.dart';

class ViewMap extends StatefulWidget {
  const ViewMap({super.key});

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final LatLng _kigaliCenter =
      const LatLng(-1.9441, 30.0619); // Coordinates for Kigali center
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP;
  Map<PolylineId, Polyline> polylines = {};
  final Map<PolygonId, Polygon> _polygons = {};
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipPath(
          clipper: AppBarClipPath(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryRed, primaryRed.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'View Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _currentP == null
          ? Center(
              child: CircularProgressIndicator(color: primaryRed),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _kigaliCenter,
                zoom: 13,
              ),
              polygons: Set<Polygon>.of(_polygons.values),
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                const Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex),
                const Marker(
                    markerId: MarkerId("_destionationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pApplePark)
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  void _startLocationUpdates() async {
    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      // Check if the device's location is inside or outside the geofence
      // bool insideGeofence = _isLocationInsideGeofence(
      //     currentLocation.latitude!, currentLocation.longitude!);

      // if (insideGeofence && !_notificationSentInSide) {
      //   _triggerInSideNotification();
      //   _notificationSentInSide = true;
      //   _notificationSentOutSide = false;
      // } else if (!insideGeofence && !_notificationSentOutSide) {
      //   _triggerOutSideNotification();
      //   _notificationSentOutSide = true;
      //   _notificationSentInSide = false;
      // }
    });
  }

  bool _isLocationInsideGeofence(double latitude, double longitude) {
    // Check if the provided location is inside the geofence boundaries
    bool isInside = false;
    List<LatLng> kigaliBoundaries = [
      const LatLng(-1.9740, 30.0274),
      const LatLng(-1.9740, 30.1300),
      const LatLng(-1.8980, 30.1300),
      const LatLng(-1.8980, 30.0274),
    ];

    // Algorithm to determine if a point is inside a polygon
    int i, j = kigaliBoundaries.length - 1;
    for (i = 0; i < kigaliBoundaries.length; i++) {
      if ((kigaliBoundaries[i].latitude < latitude &&
                  kigaliBoundaries[j].latitude >= latitude ||
              kigaliBoundaries[j].latitude < latitude &&
                  kigaliBoundaries[i].latitude >= latitude) &&
          (kigaliBoundaries[i].longitude <= longitude ||
              kigaliBoundaries[j].longitude <= longitude)) {
        if (kigaliBoundaries[i].longitude +
                (latitude - kigaliBoundaries[i].latitude) /
                    (kigaliBoundaries[j].latitude -
                        kigaliBoundaries[i].latitude) *
                    (kigaliBoundaries[j].longitude -
                        kigaliBoundaries[i].longitude) <
            longitude) {
          isInside = !isInside;
        }
      }
      j = i;
    }
    return isInside;
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng newLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        // Update the marker to the new location
        updateMarkerAndCircle(newLocation);

        // Optionally, keep track of the path by adding to your polyline
        addLocationToPolyline(newLocation);

        _cameraToPosition(newLocation);
      }
    });
  }

  void updateMarkerAndCircle(LatLng newLocation) {
    setState(() {
      _currentP = newLocation;
      // Update your marker or create a new one if needed
    });
  }

  void addLocationToPolyline(LatLng newLocation) {
    setState(() {
      // Check if polyline exists, if not create one
      if (polylines.containsKey(const PolylineId("path"))) {
        final polyline = polylines[const PolylineId("path")]!;
        final updatedPoints = List<LatLng>.from(polyline.points)
          ..add(newLocation);
        polylines[const PolylineId("path")] =
            polyline.copyWith(pointsParam: updatedPoints);
      } else {
        // Create new polyline if it doesn't exist
        polylines[const PolylineId("path")] = Polyline(
          polylineId: const PolylineId("path"),
          color: Colors.blue,
          points: [newLocation],
          width: 5,
        );
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['GOOGLE_MAPS_API_KEY']!,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
