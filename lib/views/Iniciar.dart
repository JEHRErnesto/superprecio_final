import 'package:flutter/material.dart';
import 'package:superprecio/views/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espera n segundos y luego navega a la página de inicio de sesión
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'img/icono/Superprecio.png'), // Reemplaza 'your_image.png' con la ubicación de tu imagen
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    100), // Ajusta el valor para cambiar la cantidad de redondeo
                color: Colors.white, // Color de fondo del Card
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  '¡ENCUENTRA EL MEJOR PRECIO, EN CADA VIAJE Y BOCADO!',
                  style: TextStyle(fontSize: 20, fontFamily: 'MiFuente'),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
