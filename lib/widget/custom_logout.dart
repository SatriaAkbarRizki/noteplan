import 'package:flutter/material.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/presenter/database_profile.dart';

import '../auth/authemail.dart';
import '../auth/authgoogle.dart';
import '../presenter/saveuid.dart';

class CustomLogOut extends StatefulWidget {
  final String keyProfile;
  const CustomLogOut(this.keyProfile, {super.key});

  @override
  State<CustomLogOut> createState() => _CustomLogOutState();
}

class _CustomLogOutState extends State<CustomLogOut> {
  DatabaseProfile databaseProfile =
      DatabaseProfile(uid: MainState.currentUid.toString());
  final double padding = 20;
  final double avatarRadius = 45;
  final double spacingWIdget = 20;
  final AuthEmail authEmail = AuthEmail();
  final SaveUid localUid = SaveUid();

  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: contentBox(),
    );
  }

  Widget contentBox() {
    return Stack(
      children: [
        Container(
          height: 250,
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: padding),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(171, 0, 0, 0),
                    offset: Offset(15, 20),
                    blurRadius: 5),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Log Out from NotePlan??',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: spacingWIdget,
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 45,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(MyColors.colorCancel),
                            backgroundColor: MaterialStatePropertyAll(
                                MyColors.colorBackgroundHome),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.black),
                            shape: const MaterialStatePropertyAll(
                                BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(color: Colors.black),
                            )))),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    height: 45,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () async {
                          await authEmail.signOutEmail().whenComplete(
                              () async =>
                                  await localUid.removeUid().whenComplete(() {
                                    AuthGoogle()
                                        .googleSignIn
                                        .disconnect()
                                        .whenComplete(() async {
                                      databaseProfile
                                          .removeProfile(widget.keyProfile);
                                      Navigator.pushReplacementNamed(
                                          context, '/SignIn');
                                    });
                                  }));
                        },
                        child: const Text('Yes'),
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(MyColors.colorButton),
                            backgroundColor: MaterialStatePropertyAll(
                                MyColors.colorBackgroundHome),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.black),
                            shape: const MaterialStatePropertyAll(
                                BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(color: Colors.black),
                            )))),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
