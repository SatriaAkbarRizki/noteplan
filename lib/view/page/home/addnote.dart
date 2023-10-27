import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/format/markdowncustom.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/presenter/adding.dart';
import 'package:noteplan/storage/cloudstorage.dart';
import 'package:noteplan/presenter/presenter.dart';

class AddNote extends StatefulWidget {
  String? uid;
  AddNote({required this.uid, super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  XFile? _image;
  Presenter? presenter;
  static FocusNode focusTitle = FocusNode();
  static FocusNode focusDesc = FocusNode();
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
    ),
    r"-(.*?)\-": const TextStyle(color: Colors.red)
  });

  final CustomTextEditingController titleController =
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
    ),
    r"-(.*?)\-": const TextStyle(color: Colors.red)
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)?.settings.arguments;
    // debugdebugPrint('Have UID in addnote?? : ${uid}');
    return Scaffold(
      backgroundColor: MyColors.colorBackgroundHome,
      body: GestureDetector(
        onTap: () {
          focusTitle.unfocus();
          focusDesc.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              WriteNotes(),
              ActionNote(
                keyData: uid.toString(),
                uid: uid,
                title: titleController.text,
                imagePath: _image,
                description: textController.text,
              )
            ],
          ),
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
                    setState(() {});
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.left,
                  controller: titleController,
                  maxLines: null,
                  decoration: InputDecoration.collapsed(
                    hintText: "Whats title here..",
                    hintStyle: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                    visible: _image == null ? false : true,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5)),
                      child: Image.file(File(_image?.path ?? ''),
                          fit: BoxFit.cover),
                    )),
                Visibility(
                  visible: _image != null ? true : false,
                  child: SizedBox(
                    height: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () => focusTitle.requestFocus(),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    focusNode: focusDesc,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    controller: textController,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                      hintText: "Let's Write Notes..",
                    ),
                  ),
                ),
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
                  debugPrint(
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
              GestureDetector(
                onTap: () async {
                  _image = await getImage();
                  debugPrint('Source Image : ${_image!.path}');
                  setState(() {});
                  // var value = "-${_image!.path}-";
                  // if (_image!.path.isNotEmpty) {
                  //   setState(() {
                  //     textController.text = textController.text.replaceRange(
                  //         textController.text.length, null, ' ${value}');
                  //   });
                  // }
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
        SizedBox(
          height: 20,
        ),
      ],
    );
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

  Future<XFile?> getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      return image;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

class ActionNote extends StatelessWidget {
  final date = DateFormat("d/M/y").format(DateTime.now());
  final time = DateFormat("h:mm a' '-' 'E'").format(DateTime.now());
  CloudStorage cloudStorage = CloudStorage();
  AddingNote? addingNote;
  final String? keyData;
  final Object? uid;
  final String? title;
  final XFile? imagePath;
  final String? description;
  ActionNote(
      {required this.keyData,
      required this.uid,
      required this.title,
      required this.imagePath,
      required this.description,
      super.key});

  File? imageFile;
  String? linkImage;

  @override
  Widget build(BuildContext context) {
    imageFile = File(imagePath?.path != null ? imagePath!.path : "");

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
                  onPressed: () async {
                    _AddNoteState.focusTitle.unfocus();
                    _AddNoteState.focusDesc.unfocus();
                    await cloudStorage.uploadImage(imageFile).then((value) {
                      linkImage = value;
                      debugPrint('result links??: ${value}');
                    }).whenComplete(() async {
                      await addingData(keyData.toString(), uid, title!,
                              linkImage, description!)
                          .whenComplete(
                              () => Navigator.pushNamed(context, '/Home'));
                    });
                  },
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

  Future addingData(String keyData, Object? uid, String title, String? image,
      String description) async {
    addingNote = AddingNote(uid: uid.toString());
    final note = NoteModel(
        keyData: keyData,
        title: title,
        image: image,
        description: description,
        date: date,
        time: time);
    addingNote!.saveNote(note);
  }
}
