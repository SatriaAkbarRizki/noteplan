import 'package:flutter/material.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/presenter/database_plan.dart';
import 'package:noteplan/view/page/home/plan/editplan.dart';

class HomePlan extends StatefulWidget {
  const HomePlan({super.key});

  @override
  State<HomePlan> createState() => _HomePlanState();
}

class _HomePlanState extends State<HomePlan> {
  bool isExpandd = true;
  Map<String, List> listMapPlan = {};
  List keyPlanUser = [];
  late DatabasePlan databasePlan;

  @override
  void initState() {
    databasePlan = DatabasePlan(uid: MainState.currentUid.toString());
    parsingData();
    super.initState();
  }

  Future parsingData() async {
    Map<String, Map<dynamic, dynamic>> mapOfMaps = {};
    await databasePlan.readPlan().then((value) async => mapOfMaps = value);

    mapOfMaps.forEach((key, value) {
      keyPlanUser.add(key);
      value.forEach((innerKey, innerValue) {
        listMapPlan[innerKey] = innerValue;
      });
    });

    return listMapPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const TittleBar(),
        FutureBuilder(
          future: parsingData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return listPlanUser(listMapPlan);
            } else {
              return EmptyPlan();
            }
          },
        )
      ],
    ));
  }

  Widget listPlanUser(Map<String, List> listMapPlan) {
    List<String> title = List.from(listMapPlan.keys);

    return Expanded(
      child: ListView.builder(
        itemCount: title.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              color: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      '${title[index]}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    trailing: IconButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/EditPlan',
                            arguments: EditPlan(
                                keyUser: keyPlanUser[index],
                                title: title[index],
                                subListUser: listMapPlan[title[index]]!)),
                        icon: Icon(Icons.edit)),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listMapPlan[title[index]]!.length,
                    itemBuilder: (context, subIndex) => ListTile(
                      title: Text(
                        '${listMapPlan[title[index]]![subIndex]}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          print(subIndex);
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future updateSubPlan(
      String key, String title, List<dynamic> subListPlan) async {
    Map<String, List> toMap = {};
    setState(() {
      toMap[title] = subListPlan;
    });

    toMap.forEach((key, value) {
      print('key: ${key} and value: ${value}');
    });
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
                    text: "Plans is Empty, let's ",
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
