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

  void _getCurrentLocation() async {
    try {
      _currentPosition = await determinePosition();
      if (_currentPosition != null) {
        LatLng initialPosition =
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        _updateCameraPosition(initialPosition);
      }
    } catch (e) {
      print('Error obtaining current location: $e');
    }
  }

  void _addMarkers() async {
    Future<BitmapDescriptor> _loadCustomIcon(String imagePath) async {
      final ByteData byteData = await rootBundle.load(imagePath);
      final Uint8List uint8List = byteData.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(uint8List);
    }

    final BitmapDescriptor puma = await _loadCustomIcon('img/gasolineras/puma.png');
    final BitmapDescriptor texaco = await _loadCustomIcon('img/gasolineras/Texaco.png');
    final BitmapDescriptor uno = await _loadCustomIcon('img/gasolineras/UNO.png');

    _markers.add(
      Marker(
        markerId: MarkerId('marker_id_1'),
        position: LatLng(13.504599, -88.874398), // Ubicación específica 1
        icon: texaco,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título encima de la imagen
                    Text(
                      'Gasolinera Texaco',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Imagen
                    Center(
                      child: Image.asset(
                        'img/gasolineras/Texaco.png',
                        height: 200,
                        width: 200,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Título "Gasolina"
                    Text(
                      'Gasolina',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // Precios de gasolina
                    Text('Regular: \$4.10'),
                    Text('Super: \$4.48'),
                    SizedBox(
                      height: 10,
                    ),
                    // Título "Diesel"
                    Text(
                      'Diesel: \$3.99',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Botón "Dar ubicación"
                    ElevatedButton(
                      onPressed: () {
                        _calculateAndDisplayRoute(
                          const LatLng(13.504599,
                              -88.874398), // Cambia esto por la posición del marcador
                        );
                      },
                      child: Text('Dar ubicación'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('marker_id_2'),
        position: LatLng(13.497174, -88.877471), // Ubicación específica 2
        icon: uno,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título encima de la imagen
                    Text(
                      'Gasolinera UNO',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    // Imagen
                    Center(
                      child: Image.asset(
                        'img/gasolineras/UNO.png',
                        height: 200,
                        width: 200,
                      ),
                    ),

                    // Título "Gasolina"
                    Text(
                      'Gasolina',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // Precios de gasolina
                    Text('Regular: \$4.15'),
                    Text('Super: \$4.50'),
                    SizedBox(
                      height: 10,
                    ),
                    // Título "Diesel"
                    Text(
                      'Diesel: \$3.80',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Botón "Dar ubicación"
                    ElevatedButton(
                      onPressed: () {
                        _calculateAndDisplayRoute(
                          const LatLng(13.497174,
                              -88.877471), // Cambia esto por la posición del marcador
                        );
                      },
                      child: Text('Dar ubicación'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('marker_id_3'),
        position: LatLng(13.504898, -88.874929), // Ubicación específica 2
        icon: puma,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título encima de la imagen
                    Text(
                      'Gasolinera PUMA',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    // Imagen
                    Center(
                      child: Image.asset(
                        'img/gasolineras/puma.png',
                        height: 200,
                        width: 200,
                      ),
                    ),

                    // Título "Gasolina"
                    Text(
                      'Gasolina',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // Precios de gasolina
                    Text('Regular: \$4.05'),
                    Text('Super: \$4.46'),
                    SizedBox(
                      height: 10,
                    ),
                    // Título "Diesel"
                    Text(
                      'Diesel: \$3.95',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Botón "Dar ubicación"
                    ElevatedButton(
                      onPressed: () {
                        _calculateAndDisplayRoute(
                          const LatLng(13.504898,
                              -88.874929), // Cambia esto por la posición del marcador
                        );
                      },
                      child: Text('Dar ubicación'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
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

  void _updateCameraPosition(LatLng target) {
    setState(() {
      _loadCustomIcon().then((BitmapDescriptor customIcon) {
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: target,
            icon: customIcon,
          ),
        );

        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: target,
              zoom: 15.0, // Ajusta el nivel de zoom según tus necesidades
            ),
          ),
        );
      });
    });
  }

  Future<BitmapDescriptor> _loadCustomIcon() async {
    final ByteData byteData = await rootBundle.load('img/pin/pin.png');
    final Uint8List uint8List = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(uint8List);
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
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          _getCurrentLocation(); // Actualiza la ubicación actual al presionar el botón
        },
        child: Image.asset('img/iconos/centrar.png', width: 30, height: 30),
      ),
    );
  }
}

