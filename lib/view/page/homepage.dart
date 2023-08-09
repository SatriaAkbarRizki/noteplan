import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/presenter/presenter.dart';
import 'package:noteplan/view/page/loginpage.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  HomePage({required this.uid, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Presenter presenter = Presenter(uid: 'afsafsfas1213');
  AuthGoogle authGoogle = AuthGoogle();
  AuthEmail authEmail = AuthEmail();

  int? data;

  @override
  void initState() {
    // presetData();
    authGoogle.googleSignIn.signInSilently();
    super.initState();
  }

  void presetData() async {
    presenter.parsingData().then((value) {
      data = value!.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('present: ${presenter.parsingData().then((value) {
      print(value!.length);
    })}');
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        leading: IconButton(
            onPressed: () async {
              authEmail.auth.signOut();
              authGoogle.googleSignIn.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Text('Welcome and uid you : ${widget.uid}'),
      ),
    );
  }
}
