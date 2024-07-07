import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  List<Map<String, dynamic>> _allReported = [];
  Set<Marker> _markers = {};

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(reportedsURL));

    if (response.statusCode == 200) {
      // print(_currentP);
      setState(() {
        final decodedResponse = json.decode(response.body);
        final List<dynamic> decodedReporteds = decodedResponse['reported'];
        final List<Map<String, dynamic>> reporteds =
            List<Map<String, dynamic>>.from(decodedReporteds);
        _allReported = reporteds;
        _markers = {
          Marker(
            markerId: const MarkerId("_currentLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _currentP!,
          ),
          ..._allReported.map((report) {
            return Marker(
              markerId: MarkerId(report['id'].toString()),
              position: LatLng(
                report['location_latitude'],
                report['location_longitude'],
              ),
              infoWindow: InfoWindow(
                title: report['title'],
                snippet: report['description'],
              ),
              icon: BitmapDescriptor.defaultMarker,
            );
          }).toSet()
        };
      });
    } else {
      // print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
              // markers: {
              //   Marker(
              //     markerId: const MarkerId("_currentLocation"),
              //     icon: BitmapDescriptor.defaultMarker,
              //     position: _currentP!,
              //   ),
              // },
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
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
      // print(result.errorMessage);
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
