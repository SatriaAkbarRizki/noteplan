import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/model/users.dart';
import 'package:noteplan/presenter/presenter.dart';
import 'package:noteplan/view/page/home/addnote.dart';

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
      body: Column(
        children: [TittleBar(), ListNotes()],
      ),
    );
  }

  Widget TittleBar() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'your notes',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'montserrat',
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {
              print('Trigger Add');
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(style: BorderStyle.solid, color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.add),
            ),
          ),
        )
      ],
    );
  }

  Widget ListNotes() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 10, top: 20),
              child: SizedBox(
                height: 150,
                width: 2,
                child: VerticalDivider(
                  thickness: 6,
                  color: Color(0xffD8D9DA),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Container(
                    width: 300,
                    constraints: BoxConstraints(minHeight: 150),
                    decoration: BoxDecoration(
                      color: Color(0xffE19898),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'sssafffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffaaaaaaaaaaa',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Visibility(
                              visible: true,
                              child: Container(
                                height: 200,
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(45),
                                    color: Color(0xffFFE5AD)),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
