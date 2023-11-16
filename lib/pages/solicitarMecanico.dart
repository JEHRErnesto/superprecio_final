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
        body: MecanicoForm(),
      ),
    );
  }
}

class MecanicoForm extends StatefulWidget {
  @override
  _MecanicoFormState createState() => _MecanicoFormState();
}

class _MecanicoFormState extends State<MecanicoForm> {
  bool mecanicoEnCamino = false;

  void solicitarMecanico() {
    // Simular una solicitud de mecánico (aquí puedes agregar la lógica real)
    setState(() {
      mecanicoEnCamino = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (mecanicoEnCamino)
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
