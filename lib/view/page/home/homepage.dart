import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/presenter/adding.dart';
import 'package:noteplan/presenter/presenter.dart';
import 'package:noteplan/presenter/saveuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  HomePage({required this.uid, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Presenter presenter = Presenter(uid: 'afsafsfas1213');
  AddingNote addingNote = AddingNote(uid: SaveUid.uidUser.toString());
  AuthGoogle authGoogle = AuthGoogle();
  AuthEmail authEmail = AuthEmail();
  var _listnote = <NoteModel>{};
  List<NoteModel>? toListNote;
  String? uidCurrent;

  @override
  void initState() {
    parsingData();
    authGoogle.googleSignIn.signInSilently();
    super.initState();
  }

  Future parsingData() async {
    await addingNote.readData().then((value) {
      _listnote = value!.toSet();
      toListNote = _listnote.toList();
    });

    print('length listnote: ${_listnote?.length}');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    setState(() {});
    print('length listnote: ${_listnote.length}');
    return Scaffold(
      backgroundColor: MyColors.colorBackgroundHome,
      body: Column(
        children: [
          TittleBar(uidCurrent),
          FutureBuilder<List<NoteModel>?>(
            future: addingNote!.readData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  return ListNotes(toListNote!);
                } else {
                  return Expanded(
                      child:
                          Center(child: Text('Eror Found: ${snapshot.error}')));
                }
              }
            },
          )
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
              Navigator.pushNamed(context, '/AddNote',
                  arguments: SaveUid.uidUser);
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

  Widget ListNotes(List<NoteModel> notemodelList) {
    print('length: ${notemodelList.length}');

    // Note Solve
    final date = DateFormat("d/M/y").format(DateTime.now());
    final time = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: notemodelList!.length,
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
                            Text('Date: ${notemodelList![index].date}',
                                style: TextStyle(
                                  fontFamily: 'wixmadefor',
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Time: ${notemodelList![index].time}',
                                style: TextStyle(fontFamily: 'wixmadefor'))
                          ],
                        )),
                      ),
                    );
                  },
                  child: Text(
                    '${notemodelList![index].date}',
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
                                  '${notemodelList![index].title}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'wixmadefor',
                                      height: 2,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${notemodelList![index].description}',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'wixmadefor',
                                    height: 2,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Visibility(
                                    visible: notemodelList![index].image != null
                                        ? true
                                        : false,
                                    child: Container(
                                      height: 200,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                notemodelList![index]
                                                    .image
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fill),
                                          borderRadius:
                                              BorderRadius.circular(15),
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
