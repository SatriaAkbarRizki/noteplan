import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteplan/presenter/saveuid.dart';
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
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainApp> {
  static String? currentUid;
  SaveUid saveUid = SaveUid();
  @override
  void initState() {
    haveAuth();
    super.initState();
  }

  Future haveAuth() async {
    await saveUid.getUid().then((value) async {
      if (value != null) {
        setState(() {
          currentUid = value.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('curretn: ${currentUid}');
    return MaterialApp(
      routes: {
        '/Home': (context) => HomePage(uid: null),
        '/SignIn': (context) => SignIn(),
        '/SignUp': (context) => SignUpEmail(),
        '/Reset': (context) => ResetPass(),
        '/AddNote': (context) => AddNote(uid: null),
        '/ViewNote': (context) => ViewNote(
              currentNote: [],
            )
      },
      debugShowCheckedModeBanner: false,
      home: currentUid != null ? HomePage(uid: currentUid!) : SignIn(),
    );
  }
}
