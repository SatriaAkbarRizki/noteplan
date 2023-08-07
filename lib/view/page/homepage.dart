import 'package:flutter/material.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/view/page/loginpage.dart';

class HomePage extends StatefulWidget {
  final dynamic uid;
  HomePage({required this.uid, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthGoogle authGoogle = AuthGoogle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        leading: IconButton(
            onPressed: () async {
              await authGoogle.googleSignIn.signOut();
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
