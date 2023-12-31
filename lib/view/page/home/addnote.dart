import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/format/markdowncustom.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/presenter/database_note.dart';
import 'package:noteplan/storage/cloudstorage.dart';
import 'package:photo_view/photo_view.dart';

class AddNote extends StatefulWidget {
  final String? uid;
  AddNote({required this.uid, super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  XFile? _imageName;

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
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          focusTitle.unfocus();
          focusDesc.unfocus();
        },
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
                ActionNote(
                  uid: uid,
                  title: titleController.text,
                  imagePath: _imageName,
                  description: textController.text,
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
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: const InputDecoration.collapsed(
                    hintText: "Whats title here..",
                    hintStyle: TextStyle(fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                    visible: _imageName == null ? false : true,
                    child: Animate(
                      effects: [FadeEffect(duration: 500.ms, delay: 100.ms)],
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: Center(
                                child: PhotoView(
                                  imageProvider:
                                      FileImage(File(_imageName?.path ?? '')),
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Card(
                          child: Image.file(File(_imageName?.path ?? ''),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )),
                Visibility(
                  visible: _imageName != null ? true : false,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () => focusTitle.requestFocus(),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    focusNode: focusDesc,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    controller: textController,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Let's Write Notes..",
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
        Container(
          height: 50,
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
              const SizedBox(
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
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  _imageName = await getImage();
                  debugPrint('Source Image : ${_imageName!.path}');
                  setState(() {});
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
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
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
  DatabaseNote? databaseNote;
  final Object? uid;
  final String? title;
  final XFile? imagePath;
  final String? description;
  ActionNote(
      {required this.uid,
      required this.title,
      required this.imagePath,
      required this.description,
      super.key});

  File? directoryImage;
  String? linkImage;

  @override
  Widget build(BuildContext context) {
    directoryImage = File(imagePath?.path != null ? imagePath!.path : "");

    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 160,
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Home');
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
        Expanded(
          child: const SizedBox(
            width: 30,
          ),
        ),
        SizedBox(
          height: 50,
          width: 160,
          child: ElevatedButton(
              onPressed: () async {
                _AddNoteState.focusTitle.unfocus();
                _AddNoteState.focusDesc.unfocus();
                await cloudStorage.uploadImage(directoryImage).then((value) {
                  linkImage = value;
                  debugPrint('result links??: ${value}');
                }).whenComplete(() async {
                  await addingData(
                          uid.toString(), title!, linkImage, description!)
                      .whenComplete(
                          () => Navigator.pushNamed(context, '/Home'));
                });
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

  Future addingData(
      Object? uid, String title, String? image, String description) async {
    databaseNote = DatabaseNote(uid: uid.toString());
    final note = NoteModel(
        keyData: uid.toString(),
        title: title,
        image: image,
        description: description,
        date: date,
        time: time);
    databaseNote!.saveNote(note);
  }
}
