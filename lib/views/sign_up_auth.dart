import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superprecio/user_auth/firebase_auth_services.dart';
import 'package:superprecio/views/login_page.dart';
import 'package:superprecio/widget/input_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        //
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                InputWidget(
                  controller: _usernameController,
                  hintText: "Nombre de Usuario",
                  isPasswordField: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputWidget(
                  controller: _emailController,
                  hintText: "Correo electrónico",
                  isPasswordField: false,
                  icon: Icons.email,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputWidget(
                  controller: _passwordController,
                  hintText: "Contraseña",
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿Ya tienes cuenta?"),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
  String username = _usernameController.text;
  String email = _emailController.text;
  String password = _passwordController.text;

  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      String userId = userCredential.user!.uid; // Acceso seguro ya que sabemos que user no es nulo

      // Guarda el nombre de usuario en Firestore
      await FirebaseFirestore.instance.collection('usuario').doc(userId).set({
        'username': username,
        // Otros campos de usuario que desees almacenar
      });

      print("Usuario agregado satisfactoriamente.");
      Navigator.pushNamed(context, "/login");
    } else {
      print("No se pudo obtener el ID del usuario.");
    }
  } catch (error) {
    print("Error al registrar al usuario: $error");
  }
}

}
