import 'dart:async';
import 'dart:math';
import 'package:flutter_google_maps_webservices/directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps_flutter;
import 'package:flutter_google_maps_webservices/directions.dart' as google_directions;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};
  Set<google_maps_flutter.Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Position? _currentPosition;

  final directionsApiClient =
      GoogleMapsDirections(apiKey: 'AIzaSyD57kSeEEU11CaUK30VHYl-8i9M58ePwP8');

   @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addMarkers();

    Timer.periodic(Duration(seconds: 10), (timer) {
      // Obtener la ubicación actual y actualizar la ruta
      _getCurrentLocation();
    });
  }


  void _calculateAndDisplayRoute(LatLng destination) async {
    if (_currentPosition == null) {
      return;
    }

    PointLatLng origin =
        PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    PointLatLng destinationPoint =
        PointLatLng(destination.latitude, destination.longitude);

    DirectionsResponse response = await directionsApiClient.directions(
      Location(lat: origin.latitude, lng: origin.longitude),
      Location(lat: destinationPoint.latitude, lng: destinationPoint.longitude),
      travelMode: google_directions.TravelMode.driving,
    );

    if (response.status == 'OK') {
      List<LatLng> route = [];

      for (var step in response.routes[0].legs[0].steps) {
        final startLocation = step.startLocation;
        final endLocation = step.endLocation;

        route.add(LatLng(startLocation.lat, startLocation.lng));
        route.add(LatLng(endLocation.lat, endLocation.lng));
      }

      // Borra las polilíneas existentes
      _polylines.clear();

      // Añade la nueva polilínea
      setState(() {
        _polylines.add(google_maps_flutter.Polyline(
          polylineId: const PolylineId('polyline'),
          points: route,
          width: 5,
          color: Colors.red,
        ));
      });

      // Ajusta la cámara para que muestre toda la ruta
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(min(origin.latitude, destinationPoint.latitude),
            min(origin.longitude, destinationPoint.longitude)),
        northeast: LatLng(max(origin.latitude, destinationPoint.latitude),
            max(origin.longitude, destinationPoint.longitude)),
      );
      _googleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      print('Error al calcular la ruta: ${response.errorMessage}');
    }
  }

// Método para actualizar la ruta en función de la nueva posición del usuario
  void _updateRoute(LatLng currentPosition) {
    if (_polylines.isNotEmpty) {
      // Convierte el conjunto a una lista
      List<google_maps_flutter.Polyline> polylinesList = _polylines.toList();

      // Obtén la última polilínea
      List<LatLng> existingRoute = polylinesList[0].points;

      // Añade la nueva posición del usuario a la ruta existente
      existingRoute
          .add(LatLng(currentPosition.latitude, currentPosition.longitude));

      // Actualiza la polilínea
      setState(() {
        _polylines.clear();
        _polylines.add(google_maps_flutter.Polyline(
          polylineId: const PolylineId('polyline'),
          points: existingRoute,
          width: 5,
          color: Colors.red,
        ));
      });
    }
  }


  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permiso');
      }
    }
    return await Geolocator.getCurrentPosition();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Valores iniciales que se actualizarán
          zoom: 5.5,
        ),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
      ),
    );
  }
}

