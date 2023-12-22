// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/presenter/database_plan.dart';

import '../../../../color/colors.dart';
import '../../../../presenter/database_note.dart';

class EditPlan extends StatefulWidget {
  final String? keyUser;
  final String? title;
  final List<dynamic>? subListUser;

  const EditPlan(
      {required this.keyUser,
      required this.title,
      required this.subListUser,
      super.key});

  @override
  State<EditPlan> createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  int addItem = 1;
  String? keyPlan;
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

  void updateValueController(int index, String? value) {
    TextEditingController updatePlan = TextEditingController();
    updatePlan.text = value!;
    controllers[index] = updatePlan;
  }

  void removevPlanItem(int index) {
    listPlan.removeAt(index);
  }

  void removeValueController(int index) {
    controllers.removeAt(index);
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

  Future parsingData() async {
    final data = ModalRoute.of(context)?.settings.arguments as EditPlan;

    keyPlan = data.keyUser;
    titleController.text = data.title!;
    controllers = List.generate(data.subListUser!.length,
        (index) => TextEditingController(text: data.subListUser![index]));
    setState(() {
      listPlan = List.generate(
          controllers.length, (index) => controllers[index]!.text);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => parsingData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  keyPlan: keyPlan,
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
          height: 600,
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: const EdgeInsets.only(right: 5),
                      leading: IconButton(
                        icon: const Icon(Icons.add),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(255, 166, 161, 179)
                            : Colors.black,
                        onPressed: () {
                          setState(() {
                            addPlanItem(controllers[index]?.text);
                            addValueController(controllers[index]?.text);
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(255, 166, 161, 179)
                            : Colors.black,
                        onPressed: () {
                          setState(() {
                            removevPlanItem(index);
                            removeValueController(index);
                          });
                        },
                      ),
                      title: TextField(
                          controller: controllers[index],
                          onChanged: (value) => updatePlanItem(index, value),
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Write plan..",
                            hintStyle: TextStyle(fontSize: 18),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  // void showListPlan() {
  //   // listPlan.forEach((element) {
  //   //   print('list on item: ${element}');
  //   // });

  //   // controllers.forEach((element) {
  //   //   print('list on controllers: ${element?.text}');
  //   // });

  //   valuePlan.forEach((key, value) {
  //     print('key: ${key} and value: ${value}');
  //   });
  //   print(valuePlan.length);
  // }
}

class ActionPlan extends StatelessWidget {
  final date = DateFormat("d/M/y").format(DateTime.now());
  final time = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
  final String? keyPlan;
  Map<String, List> listPlanUser;

  DatabasePlan? databasePlan;
  ActionPlan({required this.keyPlan, super.key, required this.listPlanUser});

  @override
  Widget build(BuildContext context) {
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
                if (listPlanUser.isNotEmpty) {
                  await updateData(keyPlan!, listPlanUser).whenComplete(
                      () => Navigator.pushNamed(context, '/Home'));
                }
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

  Future updateData(String keyPlan, Map listPlanasync) async {
    databasePlan = DatabasePlan(uid: MainState.currentUid.toString());
    databasePlan!.updatePlan(keyPlan, listPlanUser);
  }
}
