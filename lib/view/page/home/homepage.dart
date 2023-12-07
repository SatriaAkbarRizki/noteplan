import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteplan/auth/authemail.dart';
import 'package:noteplan/auth/authgoogle.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/model/profile.dart';
import 'package:noteplan/presenter/database_note.dart';
import 'package:noteplan/presenter/database_profile.dart';
import 'package:noteplan/local/saveuid.dart';
import 'package:noteplan/responsive/myresponsive.dart';
import 'package:noteplan/user/profile_user.dart';
import 'package:noteplan/widget/custom_dialog.dart';
import 'package:noteplan/widget/custom_dialognote.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  const HomePage({required this.uid, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthGoogle authGoogle = AuthGoogle();
  AuthEmail authEmail = AuthEmail();

  var _listnote = <NoteModel>{};
  late DatabaseProfile databaseProfile;
  late DatabaseNote databaseNote;

  late Offset locationClick;
  String? uidCurrent;
  SaveUid saveUid = SaveUid();
  ProfileUser profileUser = ProfileUser();

  List<NoteModel>? toListNote;
  List<ProfileModel>? _profile;

  @override
  void initState() {
    databaseNote = DatabaseNote(uid: MainState.currentUid.toString());
    databaseProfile = DatabaseProfile(uid: MainState.currentUid.toString());
    signInCheck();
    parsingData();
    parsingProfile();
    super.initState();
  }

  Future signInCheck() async {
    authGoogle.googleSignIn.signInSilently();
  }

  Future parsingData() async {
    _listnote.clear();
    toListNote?.clear();
    await databaseNote.readData().then((value) async {
      _listnote = value!.toSet();
      return _listnote;
    }).then((value) => toListNote = value.toList());

    setState(() {});
  }

  Future parsingProfile() async {
    await profileUser.getProfile().then((value) async {
      await databaseProfile.readProfile().then((value) {
        if (mounted) {
          setState(() {
            _profile = value;
          });
        }
      });
    });
  }

  Future refreshData() async {
    await parsingData();
    await parsingProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Uid on Home: ${MainState.currentUid}');

    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/AddNote',
              arguments: MainState.currentUid);
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              border: Border.all(style: BorderStyle.solid, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        edgeOffset: 80,
        color: Theme.of(context).progressIndicatorTheme.color,
        backgroundColor:
            Theme.of(context).progressIndicatorTheme.refreshBackgroundColor,
        onRefresh: refreshData,
        child: Column(
          children: [
            TittleBar(listProfile: _profile?[0]),
            FutureBuilder<List<NoteModel>?>(
              future: databaseNote.readData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(child: LoadingNote()),
                  );
                } else {
                  if (snapshot.hasData) {
                    // return listNotes(toListNote, context);
                    return listNotes(toListNote, context);
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

  Widget listNotes(List<NoteModel>? notemodelList, BuildContext context) {
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
            return Animate(
              effects: [
                FadeEffect(duration: 500.ms, delay: 200.ms),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 25),
                    child: GestureDetector(
                      onTap: () {
                        showAlertDialog(notemodelList[index]);
                      },
                      child: Text(
                        notemodelList[index].date,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(context, '/ViewNote',
                          arguments: notemodelList[index]);
                    },
                    onTapDown: (details) =>
                        locationClick = details.globalPosition,
                    onLongPress: () {
                      debugPrint('its long press');
                      showMenuNote(locationClick, notemodelList[index]);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 10, top: 20),
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
                                constraints:
                                    const BoxConstraints(minHeight: 150),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notemodelList[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Text(
                                        notemodelList[index].description,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showAlertDialog(NoteModel noteModel) async {
    await Future.delayed(const Duration(milliseconds: 200))
        .whenComplete(() => showDialog(
              context: context,
              builder: (context) => CustomDialogNote(
                noteModel: noteModel,
              ),
            ));
  }

  void showMenuNote(Offset locationMe, NoteModel noteModel) {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    showMenu(
      color: Theme.of(context).popupMenuTheme.color,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      context: context,
      position: RelativeRect.fromRect(locationClick & const Size(40, 40),
          Offset.zero & overlay!.semanticBounds.size),
      items: [
        PopupMenuItem(
          onTap: () =>
              Navigator.pushNamed(context, '/ViewNote', arguments: noteModel),
          height: 50,
          child: Row(children: [
            const Icon(Icons.edit),
            const SizedBox(
              width: 10,
            ),
            Text('Edit', style: Theme.of(context).textTheme.titleSmall)
          ]),
        ),
        PopupMenuItem(
          onTap: () {
            databaseNote.removeData(noteModel.keyData);
            refreshData();
          },
          height: 50,
          child: Row(
            children: [
              const Icon(Icons.remove_circle),
              const SizedBox(
                width: 10,
              ),
              Text('Delete', style: Theme.of(context).textTheme.titleSmall)
            ],
          ),
        ),
      ],
    );
  }
}

class TittleBar extends StatelessWidget {
  final ProfileModel? listProfile;
  const TittleBar({required this.listProfile, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => CustomProfile(
                      listProfile?.key,
                      listProfile?.name,
                      listProfile?.email,
                      listProfile?.image,
                    ));
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: listProfile?.image == null
                  ? Border.all(color: Colors.black)
                  : Border.all(color: Colors.transparent),
              shape: BoxShape.circle,
            ),
            child: listProfile?.image == null
                ? Visibility(
                    visible: true,
                    child: Image.asset(
                      "assets/images/profile.png",
                      scale: 15,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      listProfile!.image.toString(),
                    )),
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

class LoadingNote extends StatelessWidget {
  const LoadingNote({super.key});

  @override
  Widget build(BuildContext context) {
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
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Animate(
                                    effects: [
                                      ShimmerEffect(duration: 800.milliseconds)
                                    ],
                                    onPlay: (controller) => controller.repeat(),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 10,
                                          width:
                                              MyResponsive().width(context) / 3,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        )),
                                  ),
                                  Animate(
                                    effects: [
                                      ShimmerEffect(duration: 800.milliseconds)
                                    ],
                                    onPlay: (controller) => controller.repeat(),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 10,
                                          width:
                                              MyResponsive().width(context) / 2,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        )),
                                  ),
                                  Animate(
                                    effects: [
                                      ShimmerEffect(duration: 800.milliseconds)
                                    ],
                                    onPlay: (controller) => controller.repeat(),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 250,
                                          width: MyResponsive().width(context),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        )),
                                  ),
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
      ),
    );
  }
}
