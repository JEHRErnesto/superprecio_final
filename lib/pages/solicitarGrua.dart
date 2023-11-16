import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Solicitud de Mecánico'),
        ),
        body: GruaForm(),
      ),
    );
  }
}

class GruaForm extends StatefulWidget {
  @override
  _GruaFormState createState() => _GruaFormState();
}

class _GruaFormState extends State<GruaForm> {
  bool gruaEnCamino = false;

  void solicitarMecanico() {
    // Simular una solicitud de mecánico (aquí puedes agregar la lógica real)
    setState(() {
      gruaEnCamino = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (gruaEnCamino)
            Text(
              'Mecánico en camino',
              style: TextStyle(fontSize: 24.0),
            )
          else
            ElevatedButton(
              onPressed: solicitarMecanico,
              child: Text('Solicitar Mecánico'),
            ),
        ],
      ),
    );
  }
}
