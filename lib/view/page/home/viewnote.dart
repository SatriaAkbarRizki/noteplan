import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/format/markdowncustom.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/presenter/adding.dart';
import 'package:noteplan/storage/cloudstorage.dart';
import 'package:noteplan/presenter/presenter.dart';

class ViewNote extends StatefulWidget {
  List<NoteModel>? currentNote;
  ViewNote({required this.currentNote, super.key});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  XFile? _image;
  String? keyData;
  String? oldImageLink;
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handleCurrentData();
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    titleController.dispose();
    super.dispose();
  }

  Future handleCurrentData() async {
    final current = ModalRoute.of(context)?.settings.arguments as NoteModel;

    // print('see key current: ${current.keyData}');
    // print('image name :${current.image}');
    if (current.title.isNotEmpty) {
      titleController.text = current.title;
      textController.text = current.description;
      keyData = current?.keyData;
      oldImageLink = await current.image;
      if (current.image != null) {
        final data = await convertUrl(current.image.toString())
            .then((value) => _image = value);
        setState(() {
          data;
        });
      } else {
        setState(() {
          _image = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = MainState.currentUid;
    debugPrint('Uid in View Page: ${uid}');
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
                keyData: keyData,
                uid: uid,
                title: titleController.text,
                oldImageLink: oldImageLink,
                imagePath: _image ?? null,
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

  Future<XFile?> convertUrl(String? url) async {
    final file = await DefaultCacheManager().getSingleFile("${url!}");

    XFile image = await XFile(file.path);
    return image;
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
  final String? oldImageLink;
  final XFile? imagePath;
  final String? description;
  ActionNote(
      {required this.keyData,
      required this.uid,
      required this.title,
      required this.oldImageLink,
      required this.imagePath,
      required this.description,
      super.key});

  File? imageFile;
  String? linkImage;

  @override
  Widget build(BuildContext context) {
    // print('have image link?? :${oldImageLink!}');
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
                    _ViewNoteState.focusTitle.unfocus();
                    _ViewNoteState.focusDesc.unfocus();
                    //
                    await cloudStorage.uploadImage(imageFile).then((value) {
                      linkImage = value;
                    }).whenComplete(() async {
                      await updateData(
                              keyData!, uid, title!, linkImage, description!)
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

  Future updateData(String key, Object? uid, String title, String? image,
      String description) async {
    addingNote = AddingNote(uid: uid.toString());
    final note = NoteModel(
        keyData: key,
        title: title,
        image: image,
        description: description,
        date: date,
        time: time);
    addingNote!.updateData(MainState.currentUid.toString(), note);
  }
}
