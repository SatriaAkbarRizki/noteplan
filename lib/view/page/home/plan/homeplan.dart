import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/presenter/database_plan.dart';
import 'package:noteplan/view/page/home/homepage.dart';
import 'package:noteplan/view/page/home/plan/editplan.dart';

import '../../../../responsive/myresponsive.dart';

class HomePlan extends StatefulWidget {
  const HomePlan({super.key});

  @override
  State<HomePlan> createState() => _HomePlanState();
}

class _HomePlanState extends State<HomePlan> {
  late Offset locationClick;
  late DatabasePlan databasePlan;

  Map<String, bool>? isDoneMap;
  Map<String, List>? listMapPlan;
  List keyPlanList = [];

  String? keyPlanDone;
  bool isDone = false;

  @override
  void initState() {
    databasePlan = DatabasePlan(uid: MainState.currentUid.toString());
    parsingData();
    super.initState();
  }

  Future<Map<String, List<dynamic>>?> parsingData() async {
    Map<String, Map<dynamic, dynamic>>? mapOfMaps = {};
    await databasePlan.readPlan().then((value) async {
      if (value != null) {
        listMapPlan = {};
        mapOfMaps = value;
        // print(value);
        mapOfMaps?.forEach((key, value) {
          keyPlanList.add(key);
          value.forEach((innerKey, innerValue) {
            listMapPlan?[innerKey] = innerValue;
          });
        });
      } else {
        await databasePlan.removeDonePlan();
      }
    });

    await databasePlan.readDonePlan().then((value) {
      if (value != null) {
        for (var element in Map.from(value!).keys) {
          keyPlanDone = element;
        }

        isDoneMap = {};
        Map.from(value!).values.forEach((element) {
          isDoneMap = Map.from(element);
        });
      }
    });

    return listMapPlan;
  }

  Future checkDataPlan() async {
    if (listMapPlan!.isEmpty) {
      databasePlan.removeDonePlan();
    }
  }

  Future refreshData() async {
    await parsingData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const TittleBar(),
        RefreshIndicator(
          edgeOffset: 80,
          color: Theme.of(context).progressIndicatorTheme.color,
          backgroundColor:
              Theme.of(context).progressIndicatorTheme.refreshBackgroundColor,
          onRefresh: refreshData,
          child: FutureBuilder(
            future: databasePlan.readPlan(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPlan();
              } else if (snapshot.hasData) {
                return listPlanUser(listMapPlan!);
              } else {
                return const EmptyPlan();
              }
            },
          ),
        )
      ],
    ));
  }

  Widget listPlanUser(Map<String, List> listPlan) {
    List<String> title = List.from(listPlan.keys);
    List subListPlan = [];

    for (int index = 0; index < listPlan.length; index++) {
      subListPlan.add(listPlan[title[index]]);
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: title.length,
        itemBuilder: (context, index) {
          return Animate(
            effects: [
              FadeEffect(duration: 500.ms, delay: 200.ms),
            ],
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTapDown: (details) =>
                          locationClick = details.globalPosition,
                      onLongPress: () {
                        print('index on long Press: ${index}');
                        showMenuPlan(
                            locationClick, keyPlanList[index], title[index]);
                      },
                      child: ExpansionTile(
                        title: Text(
                          '${title[index]}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        trailing: IconButton(
                            style: Theme.of(context).iconButtonTheme.style,
                            onPressed: () => Navigator.pushNamed(
                                context, '/EditPlan',
                                arguments: EditPlan(
                                    keyUser: keyPlanList[index],
                                    title: title[index],
                                    subListUser: listPlan[title[index]]!)),
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            )),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: listPlan[title[index]]!.length,
                            itemBuilder: (context, subIndex) => ListTile(
                              title: Text(
                                subListPlan[index][subIndex].toString(),
                                style: isDoneMap?[subListPlan[index]
                                            [subIndex]] ==
                                        true
                                    ? const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'wixmadefor',
                                        height: 2,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2.5)
                                    : Theme.of(context).textTheme.titleSmall,
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  if (isDone == true) {
                                    isDone = false;
                                  } else if (isDone == false) {
                                    isDone = true;
                                  }
                                  setState(() {
                                    isDone;
                                  });
                                  await updateSubPlan(keyPlanDone, isDone,
                                      subListPlan[index][subIndex]);
                                },
                                icon: Icon(
                                  Icons.remove_circle,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future updateSubPlan(
      String? keyPlanDone, bool inStatus, String subListPlan) async {
    if (isDoneMap?.containsKey(subListPlan) == false) {
      isDoneMap?[subListPlan] = inStatus;
      await databasePlan.saveDonePlan(isDoneMap!);
    } else {
      if (isDoneMap?[subListPlan] != inStatus) {
        isDoneMap?.update(subListPlan, (value) => inStatus);
        await databasePlan.updateDonePlan(keyPlanDone!, isDoneMap!);
      }
    }
    setState(() {});
    // print(isDoneMap);
  }

  Future showMenuPlan(Offset locationMe, String key, String removeItem) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    showMenu(
      color: Theme.of(context).popupMenuTheme.color,
      elevation: 20,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      context: context,
      position: RelativeRect.fromRect(locationClick & const Size(40, 40),
          Offset.zero & overlay!.semanticBounds.size),
      items: [
        PopupMenuItem(
          key: Key(removeItem), // Add this line
          onTap: () async {
            await databasePlan.removePlan(key);
            listMapPlan!.remove(removeItem);
            listMapPlan!.clear();
            await refreshData();
          },
          height: 50,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.black,
                ),
              ),
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
  const TittleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Text(
              'Your Plans',
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

class EmptyPlan extends StatelessWidget {
  const EmptyPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 500.ms, delay: 200.ms),
      ],
      child: Column(
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
                  text: TextSpan(
                      text: "Plans is Empty, let's ",
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w200,
                          fontSize: 18),
                      children: [
                    TextSpan(
                        text: "Create",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18))
                  ])))
        ],
      ),
    );
  }
}

class LoadingPlan extends StatelessWidget {
  const LoadingPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Animate(
                    effects: [ShimmerEffect(duration: 800.milliseconds)],
                    onPlay: (controller) => controller.repeat(),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 10,
                          width: MyResponsive().width(context) / 2,
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor),
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
