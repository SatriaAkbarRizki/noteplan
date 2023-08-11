import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/view/page/login/sign_in.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  AuthEmail authEmail = AuthEmail();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePasword = FocusNode();

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePasword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(color: Color(0xffADC4CE)),
                ),
                Expanded(
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(color: Color(0xffD9D9D9)),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 150),
                width: 350,
                height: 350,
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
                        focusNode: _focusNodeEmail,
                        controller: emailController,
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
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 25, right: 25, top: 25),
                        child: SizedBox(
                          height: 50,
                          width: 500,
                          child: ElevatedButton(
                              onPressed: () async {
                                final result = await authEmail.signUpEmail(
                                    emailController.text,
                                    passwordController.text);

                                if (result != null) {
                                  print('Succes create account');
                                  if (result == 'Succes') {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignIn(),
                                        ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Succes created email')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(result.toString())));
                                  }
                                } else {
                                  if (emailController.text.isEmpty &&
                                      passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please enter Email and Password')));
                                  }
                                }
                              },
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xffC7EBB3)),
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.black)),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'ubuntu'),
                              )),
                        )),
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
                      text: 'Register in to your',
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
                top: 20,
                child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ));
                    },
                    icon: Image.asset(
                      "assets/logo/back.png",
                      color: Colors.black,
                    ))),
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
}
