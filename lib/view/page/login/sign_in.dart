import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/color/colors.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthEmail authEmail = AuthEmail();
  AuthGoogle authGoogle = AuthGoogle();
  GoogleSignInAccount? currentUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePasword = FocusNode();

  Future<String?> signEmail() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      final result =
          authEmail.signInEmail(emailController.text, passwordController.text);

      return result;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    authGoogle.googleSignIn.signInSilently();
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePasword.dispose();
    authEmail.auth.signOut();
    authGoogle.googleSignIn.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Status Account Google: ${currentUser}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          _focusNodeEmail.unfocus();
          _focusNodePasword.unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 400,
                  decoration:
                      BoxDecoration(color: MyColors.colorBackgroundLoginOne),
                ),
                Expanded(
                  child: Container(
                    height: 400,
                    decoration:
                        BoxDecoration(color: MyColors.colorBackgroundLogonTwo),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 150),
                width: 350,
                height: 450,
                decoration: BoxDecoration(
                    color: Color(0xffF5F3F3),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: TextField(
                        controller: emailController,
                        focusNode: _focusNodeEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontFamily: 'wixmadefor',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontFamily: 'wixmadefor',
                              fontWeight: FontWeight.w500),
                          prefixIcon: Image.asset(
                            "assets/logo/people.png",
                            scale: 1.8,
                          ),
                          prefixIconColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: TextField(
                        controller: passwordController,
                        focusNode: _focusNodePasword,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(
                            fontFamily: 'wixmadefor',
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontFamily: 'wixmadefor',
                              fontWeight: FontWeight.w500),
                          prefixIcon: Image.asset(
                            "assets/logo/password.png",
                            scale: 1.8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    ResetPass(),
                    ButtonLogin(),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 5),
                        child: SizedBox(
                          height: 55,
                          width: 500,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    'Or login with',
                                    style: TextStyle(fontFamily: 'ubuntu'),
                                  )),
                              SizedBox(
                                width: 90,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )),
                    ButtonGoogle(),
                    ButtonRegister()
                  ],
                ),
              ),
            ),
            Positioned(
                left: 140,
                child: Image.asset(
                  "assets/logo/notes.png",
                )),
            Positioned(
                left: 20,
                top: 130,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Sign in to your',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w800)),
                  TextSpan(
                      text: '\nAccount',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'poppins',
                      ))
                ]))),
            Positioned(
                left: 20,
                top: 670,
                child: Image.asset(
                  "assets/logo/notes2.png",
                )),
          ],
        ),
      ),
    );
  }

  Widget ButtonLogin() {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: SizedBox(
          height: 50,
          width: 500,
          child: ElevatedButton(
              onPressed: () async {
                try {
                  final uid = await signEmail();
                  if (uid != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/Home',
                      arguments: uid,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Email or password is incorrect.')),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? 'An error occurred.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred.')),
                  );
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(MyColors.colorButtonLogin),
                  foregroundColor: MaterialStatePropertyAll(Colors.black)),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 15, fontFamily: 'ubuntu'),
              )),
        ));
  }

  Widget ButtonGoogle() {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: SizedBox(
          height: 45,
          width: 500,
          child: ElevatedButton(
              onPressed: () async {
                await authGoogle.SignInGoogle(context).then((value) {
                  if (value != null) {
                    print('Have value?? : ${value}');
                    Navigator.pushReplacementNamed(context, '/Home',
                        arguments: value);
                  }
                });
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(MyColors.colorButtonLogin),
                  foregroundColor: MaterialStatePropertyAll(Colors.black)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/google.png",
                    height: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Google',
                    style: TextStyle(fontSize: 15, fontFamily: 'ubuntu'),
                  ),
                ],
              )),
        ));
  }

  Widget ButtonRegister() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 25),
        child: Row(
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Don’t Have Account?',
                  style: TextStyle(color: Colors.black),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/SignUp');
                      // Tambahkan tindakan yang ingin Anda lakukan saat tombol ditekan di sini.
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Color(0xff68B984)),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget ResetPass() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(top: 5, right: 15),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Reset');
        },
        child: Text(
          'Forget Password?',
          style: TextStyle(fontFamily: 'ubuntu', color: Color(0xff68B984)),
        ),
      ),
    );
  }
}
