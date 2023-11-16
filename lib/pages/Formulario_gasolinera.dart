import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapWithMarker(),
    );
  }
}

class MapWithMarker extends StatefulWidget {
  @override
  _MapWithMarkerState createState() => _MapWithMarkerState();
}

class _MapWithMarkerState extends State<MapWithMarker> {
  
  TextEditingController Regular = TextEditingController();
  TextEditingController Super = TextEditingController();
  TextEditingController Diesel = TextEditingController();

  GoogleMapController? _controller;
  File? _image;

  void _mostrarMensaje(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mensaje"),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Gasolineras')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Container(
                  height: 200,
                  width: 300, // Ajusta el tamaño del mapa según tus necesidades
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      setState(() {
                        _controller = controller;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(13.508880780413259,
                          -88.87078225041168), // Coordenadas iniciales
                      zoom: 15,
                    ),
                    markers: {
                      if (_image != null)
                        Marker(
                          markerId: MarkerId('custom'),
                          position: LatLng(13.508880780413259,
                              -88.87078225041168), // Coordenadas para el marcador
                          icon: BitmapDescriptor.fromBytes(
                              _image!.readAsBytesSync()),
                        ),
                    },
                  ),
                ),
              ),
            ),

            // Agregar los campos "Regular", "Super" y "Diesel" debajo del título
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar Imagen'),
            ),
            SizedBox(
              height: 20,
            ),

            // Envolver el formulario en un Card
            Card(
              elevation: 10, // Controla la elevación del Card
              margin: EdgeInsets.all(10), // Ajusta el margen del Card
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Gasolina',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: Regular,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'img/iconos/gasolina.png',
                              width: 5,
                              height: 5,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Regular',
                          hintText: 'Ingrese el precio de la Regular'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: Super,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'img/iconos/gasolina.png',
                              width: 5,
                              height: 5,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Super',
                          hintText: 'Ingrese el precio de la Super'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: Diesel,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'img/iconos/gasolina.png',
                              width: 5,
                              height: 5,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Diesel',
                          hintText: 'Ingrese el precio del Diesel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Regular.clear();
                        Super.clear();
                        Diesel.clear();
                        _mostrarMensaje(
                            context, "Gasolinera agregada correctamente");
                      },
                      child: Text('Agregar'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
