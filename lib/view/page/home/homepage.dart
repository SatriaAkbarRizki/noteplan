import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/presenter/presenter.dart';

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
    final args = ModalRoute.of(context)?.settings.arguments;
    print('Get UID from SIgn In: ${args}');
    return Scaffold(
      backgroundColor: MyColors.colorBackgroundHome,
      body: Column(
        children: [
          TittleBar(args),
          ListNotes(),
        ],
      ),
    );
  }

  Widget TittleBar(Object? args) {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Your Notes',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/AddNote',arguments:  args );
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
}

class ListNotes extends StatelessWidget {
  final date = DateFormat("d/M/y").format(DateTime.now());
  final time = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, top: 25),
                child: GestureDetector(
                  onTap: () {
                    print('trigger button');
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(5)),
                        backgroundColor: Color(0xffF8F0E5),
                        title: Text(
                          'Date note created',
                          style: TextStyle(fontFamily: 'wixmadefor'),
                        ),
                        content: SingleChildScrollView(
                            child: ListBody(
                          children: [
                            Text('Date: ${date}',
                                style: TextStyle(
                                  fontFamily: 'wixmadefor',
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Time: ${time}',
                                style: TextStyle(fontFamily: 'wixmadefor'))
                          ],
                        )),
                      ),
                    );
                  },
                  child: Text(
                    '${time}',
                    style: TextStyle(
                        fontFamily: 'wixmadefor',
                        fontSize: 16,
                        color: Color.fromARGB(255, 166, 161, 179)),
                  ),
                ),
              ),
              Row(
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
                                  style: TextStyle(
                                      fontFamily: 'wixmadefor', height: 2),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Visibility(
                                    visible: false,
                                    child: Container(
                                      height: 200,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(45),
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
              ),
            ],
          );
        },
      ),
    );
  }
}

class EmptyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 150),
              child: Image.asset("assets/images/thinking.png"),
            ),
            Positioned(
                left: 230,
                bottom: 240,
                child: Image.asset(
                  "assets/images/idea.png",
                  height: 100,
                )),
          ],
        ),
        Container(
            margin: EdgeInsets.only(top: 30),
            child: RichText(
                text: const TextSpan(
                    text: "Notes is Empty, let's ",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w200,
                        fontSize: 18),
                    children: [
                  TextSpan(
                      text: "Create",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18))
                ])))
      ],
    );
  }
}
