import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:superprecio/pages/home.dart';
import 'package:superprecio/views/Iniciar.dart';
import 'package:superprecio/views/login_page.dart';
import 'package:superprecio/views/sign_up_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
  
}

//void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: "/SplashScreen",
      routes: {
        "/": (context) =>  home(),
        /*"/add": (context) => const AddStudents(),
        "/edit": (context) => const EditStudents(),*/
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignUpPage(),
        "/SplashScreen": (context) =>  SplashScreen(),
      },
    );
  }
}
