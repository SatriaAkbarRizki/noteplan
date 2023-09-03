import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/format/markdowncustom.dart';
import 'package:noteplan/model/users.dart';
import 'package:noteplan/presenter/presenter.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  FocusNode focusCursos = FocusNode();
  final CustomTextEditingController textController =
      CustomTextEditingController({
    r"@.\w+": const TextStyle(
      color: Colors.blue,
    ),
    r"#.\w+": const TextStyle(
      color: Colors.blue,
    ),
    r'_(.*?)\_': const TextStyle(
      fontStyle: FontStyle.italic,
    ),
    '~(.*?)~': const TextStyle(
      decoration: TextDecoration.lineThrough,
    ),
    r'\*(.*?)\*': const TextStyle(
      fontWeight: FontWeight.bold,
    )
  });
  Presenter? presenter;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void sendData(String name, String email, String profile_image) async {
    // Perabiki logic disini
    presenter = Presenter(uid: 'afsafsfas1216');
    final user =
        UserModel(name: name, email: email, profile_image: profile_image);
    presenter!.saveData(user);
  }

  void boldText() {
    var cursosPos = textController.selection;
    final fullText = textController.text;
    final textSelect = textController.selection.textInside(textController.text);
    final replaceText = fullText.replaceAll(textSelect, '*${textSelect}*');

    //   isTextBold = !isTextBold;
    if (textController.text.isNotEmpty) {
      setState(() {
        textController.text = textController.text
            .replaceAll(textController.text, replaceText.trim());
        if (cursosPos.start > textController.text.length) {
          cursosPos = TextSelection.fromPosition(
              TextPosition(offset: textController.text.length));
        }
        textController.selection = cursosPos;
      });

      // Permasalahan nya format
    }
  }

  void italicText() {
    var cursosPos = textController.selection;
    final fullText = textController.text;
    final textSelect = textController.selection.textInside(textController.text);
    final replaceText = fullText.replaceAll(textSelect, '_${textSelect}_');

    //   isTextBold = !isTextBold;
    if (textController.text.isNotEmpty) {
      setState(() {
        textController.text = textController.text
            .replaceAll(textController.text, replaceText.trim());
        if (cursosPos.start > textController.text.length) {
          cursosPos = TextSelection.fromPosition(
              TextPosition(offset: textController.text.length));
        }
        textController.selection = cursosPos;
      });

      // Permasalahan nya format
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorBackgroundHome,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [WriteNotes(), ActionNote()],
        ),
      ),
    );
  }

  Widget WriteNotes() {
    return Column(
      children: [
        Container(
          height: 550,
          width: 350,
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
              border: Border.all(style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                TextField(
                  onChanged: (value) {
                    print(textController.text);
                  },
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.left,
                  controller: textController,
                  maxLines: null,
                  decoration: InputDecoration.collapsed(
                    hintText: "Let's Write Notes..",
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          width: 350,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  print(
                      textController.selection.textInside(textController.text));
                  boldText();
                },
                child: Image.asset(
                  "assets/icons/bold.png",
                  color: Colors.white,
                  scale: 5,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () => italicText(),
                child: Image.asset(
                  "assets/icons/italic.png",
                  color: Colors.white,
                  scale: 2.5,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Image.asset(
                "assets/icons/image.png",
                color: Colors.white,
                scale: 2.5,
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class ActionNote extends StatelessWidget {
  ActionNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 50,
              width: 160,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Home');
                  },
                  child: Text('Cancel'),
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(MyColors.colorCancel),
                      backgroundColor: MaterialStatePropertyAll(
                          MyColors.colorBackgroundHome),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                      shape: MaterialStatePropertyAll(BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(color: Colors.black),
                      )))),
            ),
            SizedBox(
              width: 30,
            ),
            SizedBox(
              height: 50,
              width: 160,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Save'),
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(MyColors.colorButtonLogin),
                      backgroundColor:
                          MaterialStatePropertyAll(MyColors.colorButtonLogin),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                      shape: MaterialStatePropertyAll(BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(color: Colors.black),
                      )))),
            )
          ],
        )
      ],
    );
  }
}
