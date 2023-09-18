import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteplan/view/page/home/addnote.dart';
import 'package:noteplan/view/page/home/homepage.dart';
import 'package:noteplan/view/page/home/viewnote.dart';
import 'package:noteplan/view/page/login/reset_password.dart';
import 'package:noteplan/view/page/login/sign_in.dart';
import 'package:noteplan/view/page/login/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
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
        '/Home': (context) => HomePage(uid: null),
        '/SignIn': (context) => SignIn(),
        '/SignUp': (context) => SignUpEmail(),
        '/Reset': (context) => ResetPass(),
        '/AddNote': (context) => AddNote(uid: null),
        '/ViewNote': (context) => ViewNote(
              currentNote: null,
            )
      },
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    );
  }
}
