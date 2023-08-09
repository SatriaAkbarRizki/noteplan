import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/model/users.dart';
import 'package:noteplan/presenter/presenter.dart';
import 'package:noteplan/view/page/addnote.dart';
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

  @override
  void initState() {
    // presetData();
    authGoogle.googleSignIn.signInSilently();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNote(),
                    ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: FutureBuilder<List<UserModel>?>(
          future: presenter.readData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('${snapshot.data![index].name}'),
                      subtitle: Text('${snapshot.data![index].email}'),
                    );
                  },
                );
              } else {
                return Text('Not Succes');
              }
            }
          },
        ),
      ),
    );
  }
}
