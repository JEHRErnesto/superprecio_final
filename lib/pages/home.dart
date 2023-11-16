import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  int ItemDrawer = 0;
  String userName =
      ''; // Agregar una variable para almacenar el nombre de usuario.

  @override
  @override
  void initState() {
    super.initState();
    // Al iniciar el widget, obtén el nombre de usuario y actualiza el estado.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getUserNameFromFirebase(user.uid).then((name) {
        setState(() {
          userName = name;
        });
      });
    }
  }

  Future<String> getUserNameFromFirebase(String userId) async {
    String userName = "";
    try {
      // Accede a la colección "usuario" y recupera el documento correspondiente al usuario actual (usando su ID).
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuario')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          userName = userData['username'] ?? '';
        }
      }
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir al acceder a Firestore.
      print('Error al obtener el nombre de usuario: $e');
    }

    return userName;
  }

  _getDrawerItem(int position) {
    switch (position) {
      /* case 0:
        return MapPage();
      case 1:
        return MapWithMarker();
      case 2:
        return GruaForm();
      case 3:
        return MecanicoForm();*/
    }
  }

  void _onSelectItemDrawer(int pos) {
    Navigator.pop(context);
    setState(() {
      ItemDrawer = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.green[300],
        title: Text(
          '\$uper Precio',
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.green[300],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 90, top: 20),
                  child: UserAccountsDrawerHeader(
                    accountName: Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: const Text(""),
                    currentAccountPicture: const CircleAvatar(
                      backgroundImage: AssetImage('img/iconos/perfil.png'),
                      radius: 60,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.white),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset(
                      'img/iconos/mapa.png',
                      height: 25,
                      width: 25,
                    ),
                    title: Text('Volver al mapa'),
                    onTap: () {
                      _onSelectItemDrawer(0);
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'img/iconos/gasolina.png',
                      width: 25,
                      height: 25,
                    ),
                    title: Text('Registrar gasolinera'),
                    onTap: () {
                      _onSelectItemDrawer(1);
                    },
                  ),
                  /* ListTile(
                    leading: Image.asset(
                      'img/iconos/gasolina.png',
                      width: 25,
                      height: 25,
                    ),
                    title: Text('Registrar restaurante'),
                    onTap: () {
                      _onSelectItemDrawer(2);
                    },
                  ),*/
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                title: Text('¿Problemas con el viaje?'),
                children: <Widget>[
                  ListTile(
                    title: Text('¿Necesitas una grua?'),
                    onTap: () {
                      _onSelectItemDrawer(2);
                    },
                  ),
                  ListTile(
                    title: Text('¿Necesitas un mecánico?'),
                    onTap: () {
                      _onSelectItemDrawer(3);
                    },
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset(
                  'img/iconos/cerrar.png',
                  height: 25,
                  width: 25,
                ),
                title: Text('Cerrar sesión'),
                onTap: () {
                  // Muestra un cuadro de diálogo de confirmación
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('¿Estás seguro de cerrar sesión?'),
                        actions: <Widget>[
                          // Botón para cerrar sesión
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamed(context, "/login");
                            },
                            child: Text('Sí'),
                          ),
                          // Botón para cancelar
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _getDrawerItem(ItemDrawer),
    );
  }
}
