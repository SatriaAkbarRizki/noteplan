import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteplan/color/colors.dart';
import 'package:noteplan/format/markdowncustom.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/note.dart';
import 'package:noteplan/presenter/database_note.dart';
import 'package:noteplan/storage/cloudstorage.dart';

class ViewNote extends StatefulWidget {
  List<NoteModel>? currentNote;
  ViewNote({required this.currentNote, super.key});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  XFile? _imageName;
  static XFile? _currentImage;
  String? keyData;
  String? oldImageLink;

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

    if (current.title.isNotEmpty) {
      titleController.text = current.title;
      textController.text = current.description;
      keyData = current?.keyData;
      oldImageLink = await current.image;
      if (current.image != null) {
        // Donwload image url
        // Convert to name image
        final data = await convertUrl(current.image.toString()).then((value) {
          _imageName = value;
          _currentImage = _imageName;
        });
        setState(() {
          data;
        });
      } else {
        setState(() {
          _imageName = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = MainState.currentUid;
    debugPrint('imageFile oldImageLink : ${oldImageLink}');
    debugPrint('_image: _imageName ${_currentImage?.name}');
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
                WriteNotes(),
                ActionNote(
                  keyData: keyData,
                  uid: uid.toString(),
                  title: titleController.text,
                  oldImageLink: oldImageLink,
                  imagePath: _imageName ?? null,
                  description: textController.text,
                )
              ],
            ),
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
          margin: const EdgeInsets.only(top: 30),
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
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5)),
                      child: Image.file(File(_imageName?.path ?? ''),
                          fit: BoxFit.cover),
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
                    focusNode: focusDesc,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium,
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
    final replaceText = fullText.replaceAll(textSelect, '*$textSelect*');

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
  DatabaseNote? databaseNote;
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

  File? directoryImage;
  String? nameImageNow;
  String? linkImage;

  @override
  Widget build(BuildContext context) {
    // print('have image link?? :${oldImageLink!}');
    directoryImage = File(imagePath?.path != null ? imagePath!.path : "");
    nameImageNow = directoryImage!.path.split('/').last;
    // debugPrint('current image :${_ViewNoteState._currentImage?.name}');
    // debugPrint('image now: $nameImageNow');
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
                  child: const Text('Cancel'),
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(MyColors.colorCancel),
                      backgroundColor: MaterialStatePropertyAll(
                          MyColors.colorBackgroundHome),
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.black),
                      shape:
                          const MaterialStatePropertyAll(BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(color: Colors.black),
                      )))),
            ),
            const SizedBox(
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
                    cloudImage(context);
                  },
                  child: const Text('Save'),
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStatePropertyAll(MyColors.colorButton),
                      backgroundColor:
                          MaterialStatePropertyAll(MyColors.colorButton),
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.black),
                      shape:
                          const MaterialStatePropertyAll(BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(color: Colors.black),
                      )))),
            )
          ],
        )
      ],
    );
  }

  Future cloudImage(BuildContext context) async {
    if (_ViewNoteState._currentImage?.name == nameImageNow) {
      await updateData(keyData!, title!, oldImageLink, description!)
          .whenComplete(() => Navigator.pushNamed(context, '/Home'));
    } else if (_ViewNoteState._currentImage?.name != nameImageNow) {
      await cloudStorage.deleteImage(oldImageLink).whenComplete(() {
        cloudStorage.uploadImage(directoryImage).then((value) {
          linkImage = value;
        }).whenComplete(() async {
          await updateData(keyData!, title!, linkImage, description!)
              .whenComplete(() => Navigator.pushNamed(context, '/Home'));
        });
      });
    } else {
      await updateData(keyData!, title!, linkImage, description!)
          .whenComplete(() => Navigator.pushNamed(context, '/Home'));
    }
  }

  Future updateData(
      String key, String title, String? image, String description) async {
    databaseNote = DatabaseNote(uid: uid.toString());
    final note = NoteModel(
        keyData: uid.toString(),
        title: title,
        image: image,
        description: description,
        date: date,
        time: time);
    databaseNote!.updateData(keyData!, note);
  }
}
