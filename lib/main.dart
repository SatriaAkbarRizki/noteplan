import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteplan/view/page/home/homepage.dart';
import 'package:noteplan/view/page/login/reset_password.dart';
import 'package:noteplan/view/page/login/sign_in.dart';
import 'package:noteplan/view/page/login/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/Home' : (context) => HomePage(uid: null),
        '/SignIn': (context) => SignIn(),
        '/SignUp': (context) => SignUpEmail(),
        '/Reset' : (context) => ResetPass()
      },
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}
