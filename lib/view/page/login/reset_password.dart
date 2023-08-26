import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/color/colors.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
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
                  decoration: BoxDecoration(color: MyColors.colorBackgroundLoginOne),
                ),
                Expanded(
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(color: MyColors.colorBackgroundLogonTwo),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 150),
                width: 350,
                height: 300,
                decoration: BoxDecoration(
                    color: Color(0xffF5F3F3),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ResetPass(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, top: 50, right: 25),
                      child: Text(
                        '*this will reset your password aaccount, please be careful!',
                        style: TextStyle(color: Color(0xffFF8989)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 20,
                left: 160,
                child: Image.asset(
                  "assets/logo/reset.png",
                  scale: 1.2,
                )),
            Positioned(
                left: 20,
                top: 150,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Reset in to your',
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
                      Navigator.pushReplacementNamed(context, '/SignIn');
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

  Widget ResetPass() {
    return Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: SizedBox(
          height: 50,
          width: 500,
          child: ElevatedButton(
              onPressed: () async {
                try {
                  if (emailController.text.isNotEmpty) {
                    final result =
                        await authEmail.resetPassword(emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Succes request reset password')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter email')));
                  }
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message.toString())));
                }
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xffC7EBB3)),
                  foregroundColor: MaterialStatePropertyAll(Colors.black)),
              child: Text(
                'Reset Password',
                style: TextStyle(fontSize: 15, fontFamily: 'ubuntu'),
              )),
        ));
  }
}
