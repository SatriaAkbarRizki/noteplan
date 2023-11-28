import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/color/thememanager.dart';
import 'package:noteplan/local/saveuid.dart';
import 'package:noteplan/widget/custom_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomProfile extends StatefulWidget {
  final String? keyProfile, name, email, image;
  CustomProfile(this.keyProfile, this.name, this.email, this.image,
      {super.key});

  @override
  State<CustomProfile> createState() => _CustomProfileState();
}

class _CustomProfileState extends State<CustomProfile> {
  final double padding = 20, avatarRadius = 45, spacingWIdget = 20;
  final AuthEmail authEmail = AuthEmail();
  final SaveUid localUid = SaveUid();
  ThemeMode _themeMode = ThemeMode.dark;
  bool inClick = true;

  @override
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
          height: 460,
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: padding),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(padding),
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
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: spacingWIdget,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.image.toString(),
                      ),
                      backgroundColor: MyColors.colorButton,
                      radius: avatarRadius,
                      child: widget.image == null
                          ? Image.asset(
                              "assets/images/profile.png",
                              scale: 5.0,
                            )
                          : Visibility(visible: true, child: SizedBox())),
                ),
              ),
              SizedBox(
                height: spacingWIdget,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.name == null
                      ? 'Not have username'
                      : widget.name.toString(),
                  style: const TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Flexible(
                      flex: 8,
                      fit: FlexFit.tight,
                      child: Text(
                        'Mode Theme',
                        style: TextStyle(fontFamily: 'poppins', fontSize: 24),
                      )),
                  Flexible(
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              inClick = !inClick;
                              ThemeManager().setThemeMode(inClick);
                            });
                          },
                          icon: inClick == true
                              ? Icon(Icons.sunny)
                              : Icon(Icons.mood)))
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            CustomLogOut(widget.keyProfile.toString()),
                      );
                    },
                    child: const Text('Log Out'),
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStatePropertyAll(MyColors.colorCancel),
                        backgroundColor: MaterialStatePropertyAll(
                            MyColors.colorBackgroundHome),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.black),
                        shape: const MaterialStatePropertyAll(
                            BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(color: Colors.black),
                        )))),
              )
            ],
          ),
        )
      ],
    );
  }
}
