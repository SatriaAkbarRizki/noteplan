import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteplan/color/mytheme.dart';
import 'package:noteplan/color/thememanager.dart';
import 'package:noteplan/local/modeUser.dart';
import 'package:noteplan/local/saveuid.dart';
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
  SaveUid saveUid = SaveUid();

  final modeUser = ModeUser();
  final savedThemeMode = await modeUser.getThemeUser();
  final savedCurrentUser = await saveUid.getUid();

  final themeMode = savedThemeMode == ThemeMode.dark.toString()
      ? ThemeMode.dark
      : ThemeMode.light;

  ThemeManager.valueNotifierTheme.value = themeMode;
  MainState.currentUid = savedCurrentUser;
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainApp> {
  static String? currentUid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('curretn: ${currentUid}');
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.valueNotifierTheme,
      builder: (context, mode, child) => MaterialApp(
        theme: MyTheme().lightTheme,
        darkTheme: MyTheme().darkTheme,
        themeMode: mode,
        routes: {
          '/Home': (context) => const HomePage(uid: null),
          '/SignIn': (context) => const SignIn(),
          '/SignUp': (context) => const SignUpEmail(),
          '/Reset': (context) => const ResetPass(),
          '/AddNote': (context) => AddNote(uid: null),
          '/ViewNote': (context) => ViewNote(
                currentNote: const [],
              )
        },
        debugShowCheckedModeBanner: false,
        home: currentUid != null ? HomePage(uid: currentUid!) : const SignIn(),
      ),
    );
  }
}
