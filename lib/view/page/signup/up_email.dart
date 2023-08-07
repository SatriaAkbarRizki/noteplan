import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  AuthEmail authEmail = AuthEmail();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Email'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 180),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
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
                      final result = await authEmail.signUpEmail(
                          emailController.text, passwordController.text);

                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Succes created email')));
                        Navigator.pop(context);
                      } else {
                        if (emailController.text.isEmpty &&
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Please enter Email and Password')));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(result)));
                        }
                      }
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
