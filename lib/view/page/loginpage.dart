import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/view/page/homepage.dart';
import 'package:noteplan/view/page/signup/up_email.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthEmail authEmail = AuthEmail();
  AuthGoogle authGoogle = AuthGoogle();
  GoogleSignInAccount? currentUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // @override
  // void initState() {
  //   authGoogle.googleSignIn.onCurrentUserChanged.listen((event) {
  //     setState(() {
  //       currentUser = event;
  //     });
  //   });

  //   authGoogle.googleSignIn.signInSilently();

  //   super.initState();
  // }

  Future<String?> signEmail() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      final result =
          authEmail.signInEmail(emailController.text, passwordController.text);
      String id = authEmail.user.uid.toString();
      return id;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Status Account Google: ${currentUser}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 180),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final uid = await signEmail();
                      if (uid != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(uid: uid)));
                      }
                    },
                    child: Text('Sign In'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpEmail()));
                      },
                      child: Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      final result = await authGoogle.SignInGoogle(context);
                      if (result != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(uid: result),
                            ));
                      }
                    },
                    icon: Image.asset('assets/images/logingoogle.png'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
