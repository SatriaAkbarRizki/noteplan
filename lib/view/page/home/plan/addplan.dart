import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/presenter/database_plan.dart';

import '../../../../color/colors.dart';

class AddPlan extends StatefulWidget {
  const AddPlan({super.key});

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  int addItem = 1;
  Map<String, List> valuePlan = {};
  late List<String?> listPlan = listPlan = List.generate(1, (index) => null);
  late List<TextEditingController?> controllers =
      List.generate(1, (index) => TextEditingController());

  TextEditingController titleController = TextEditingController();

  void addPlanItem(String? value) {
    listPlan.add(value);
  }

  void addValueController(String? value) {
    TextEditingController textPlan = TextEditingController();
    TextEditingController? textPlan2 = TextEditingController();
    textPlan.text = value!;
    textPlan2.text = '';
    controllers.add(textPlan);
    controllers.last = textPlan2;
  }

  void updatePlanItem(int index, String? value) {
    listPlan[index] = value;
  }

  void toMapPlan(String title, List<String?> listPlan) {
    if (valuePlan.length > 0) {
      valuePlan.remove(valuePlan.keys.first);
    } else {
      setState(() {
        valuePlan[title] = listPlan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('listt length: ${listPlan.length}');

    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: ListView(
              children: [
                writeNotes(),
                ActionPlan(
                  listPlanUser: valuePlan,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget writeNotes() {
    return Column(
      children: [
        Container(
          height: 550,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              border: Border.all(
                  style: BorderStyle.solid, color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    // valuePlan[titleController.text] = listPlan
                    controller: titleController,
                    onEditingComplete: () =>
                        toMapPlan(titleController.text, listPlan),
                    onTapOutside: (event) =>
                        toMapPlan(titleController.text, listPlan),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    maxLines: null,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Whats Title plan now....",
                      hintStyle: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: ListView.builder(
                    itemCount: listPlan.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ListTile(
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        title: TextField(
                            controller: controllers[index],
                            onChanged: (value) => updatePlanItem(index, value),
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Write plan..",
                              hintStyle: TextStyle(fontSize: 18),
                            )),
                        trailing: IconButton(
                          icon: new Icon(Icons.add),
                          color: Colors.black26,
                          onPressed: () {
                            setState(() {
                              addPlanItem(controllers[index]?.text);
                              addValueController(controllers[index]?.text);
                            });
                          },
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/icons/bold.png",
                  color: Colors.white,
                  scale: 5,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/icons/italic.png",
                  color: Colors.white,
                  scale: 2.5,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  showListPlan();
                },
                child: Image.asset(
                  "assets/icons/image.png",
                  color: Colors.white,
                  scale: 2.5,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void showListPlan() {
    // listPlan.forEach((element) {
    //   print('list on item: ${element}');
    // });

    // controllers.forEach((element) {
    //   print('list on controllers: ${element?.text}');
    // });

    valuePlan.forEach((key, value) {
      print('key: ${key} and value: ${value}');
    });
    print(valuePlan.length);
  }
}

class ActionPlan extends StatelessWidget {
  final date = DateFormat("d/M/y").format(DateTime.now());
  final time = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
  Map<String, List> listPlanUser;

  DatabasePlan? databasePlan;
  ActionPlan({super.key, required this.listPlanUser});

  @override
  Widget build(BuildContext context) {
    listPlanUser.forEach((key, value) {
      print('key: ${key} and value: ${value}');
    });
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 160,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
              style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(MyColors.colorCancel),
                  backgroundColor:
                      MaterialStatePropertyAll(MyColors.colorBackgroundHome),
                  foregroundColor: const MaterialStatePropertyAll(Colors.black),
                  shape: const MaterialStatePropertyAll(BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Colors.black),
                  )))),
        ),
        const Expanded(
          child: SizedBox(
            width: 30,
          ),
        ),
        SizedBox(
          height: 50,
          width: 160,
          child: ElevatedButton(
              onPressed: () async {
                listPlanUser.forEach((key, value) {
                  print('key: ${key} && value: ${value}');
                });

                Future.delayed(Duration(milliseconds: 500)).whenComplete(
                    () async => await addingData(listPlanUser).whenComplete(
                        () => Navigator.pushNamed(context, '/Home')));
              },
              child: const Text('Save'),
              style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(MyColors.colorButton),
                  backgroundColor:
                      MaterialStatePropertyAll(MyColors.colorButton),
                  foregroundColor: const MaterialStatePropertyAll(Colors.black),
                  shape: const MaterialStatePropertyAll(BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    side: BorderSide(color: Colors.black),
                  )))),
        )
      ],
    );
  }

  Future addingData(Map listPlanasync) async {
    databasePlan = DatabasePlan(uid: MainState.currentUid.toString());
    databasePlan!.savePlan(listPlanUser);
  }
}
