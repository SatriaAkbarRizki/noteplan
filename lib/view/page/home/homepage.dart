import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/presenter/adding.dart';
import 'package:noteplan/presenter/saveuid.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  const HomePage({required this.uid, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SaveUid saveUid = SaveUid();
  late AddingNote addingNote;
  AuthGoogle authGoogle = AuthGoogle();
  AuthEmail authEmail = AuthEmail();
  var _listnote = <NoteModel>{};
  List<NoteModel>? toListNote;
  String? uidCurrent;

  @override
  void initState() {
    addingNote = AddingNote(uid: MainState.currentUid.toString());
    signInCheck();
    parsingData();
    super.initState();
  }

  Future signInCheck() async {
    authGoogle.googleSignIn.signInSilently();
  }

  Future parsingData() async {
    await addingNote.readData().then((value) async {
      _listnote = value!.toSet();
      return _listnote;
    }).then((value) => toListNote = value.toList());

    setState(() {});
    // print('length toListNote: ${toListNote?.length}');
  }

  Future refreshData() async {
    setState(() {
      parsingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Uid on Home: ${MainState.currentUid}');
    return Scaffold(
      backgroundColor: MyColors.colorBackgroundHome,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/AddNote',
              arguments: MainState.currentUid);
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: MyColors.colorButtonLogin,
              border: Border.all(style: BorderStyle.solid, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.add),
        ),
      ),
      body: RefreshIndicator(
        edgeOffset: 80,
        onRefresh: refreshData,
        child: Column(
          children: [
            const TittleBar(),
            FutureBuilder<List<NoteModel>?>(
              future: addingNote.readData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (snapshot.hasData) {
                    return listNotes(toListNote);
                  } else {
                    return const Expanded(child: EmptyNote());
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget listNotes(List<NoteModel>? notemodelList) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: notemodelList!.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 25),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('trigger button');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                          backgroundColor: const Color(0xffF8F0E5),
                          title: const Text(
                            'Date note created',
                            style: TextStyle(fontFamily: 'wixmadefor'),
                          ),
                          content: ListBody(
                            children: [
                              Text('Date: ${notemodelList[index].date}',
                                  style: const TextStyle(
                                    fontFamily: 'wixmadefor',
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              Text('Time: ${notemodelList[index].time}',
                                  style:
                                      const TextStyle(fontFamily: 'wixmadefor'))
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      notemodelList[index].date,
                      style: const TextStyle(
                          fontFamily: 'wixmadefor',
                          fontSize: 16,
                          color: Color.fromARGB(255, 166, 161, 179)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, '/ViewNote',
                        arguments: notemodelList[index]);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
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
                              constraints: const BoxConstraints(minHeight: 150),
                              decoration: BoxDecoration(
                                color: const Color(0xffE19898),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notemodelList[index].title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'wixmadefor',
                                          height: 2,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      notemodelList[index].description,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontFamily: 'wixmadefor',
                                        height: 2,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Visibility(
                                        visible:
                                            notemodelList[index].image == null
                                                ? false
                                                : true,
                                        child: Container(
                                          height: 200,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  notemodelList[index]
                                                      .image
                                                      .toString(),
                                                ),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TittleBar extends StatelessWidget {
  const TittleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
            ),
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
      ],
    );
  }
}

class EmptyNote extends StatelessWidget {
  const EmptyNote({super.key});

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
            margin: const EdgeInsets.only(top: 30),
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
