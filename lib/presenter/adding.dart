import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/note.dart';

class AddingNote {
  final String uid;
  List<NoteModel>? notemodelList;
  Map<String, NoteModel>? dataUser;

  AddingNote({required this.uid});

  get reference =>
      FirebaseDatabase.instance.ref().child('Users/UID/${uid}/Note');

  Query queryFirebase() {
    return reference;
  }

  Future saveNote(NoteModel noteModel) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('Users/UID/${uid}/Note');
    if (databaseReference.key == uid) {
      updateData(uid, noteModel);
    } else {
      return databaseReference.push().set(noteModel.toJson());
    }
  }

  Future<List<NoteModel>?> readData() async {
    notemodelList = [];
    final reference = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/${MainState.currentUid.toString()}/Note')
        .once();

    final data = reference.snapshot.value as Map<dynamic, dynamic>;

    data?.forEach((key, value) {
      NoteModel noteModel = NoteModel.fromMap(key, value);
      notemodelList?.add(noteModel);
    });

    // print('length in notemodelist: ${notemodelList!.length}');
    return notemodelList;
  }

  Future updateData(String uid, NoteModel noteModel) async {
    final note = noteModel.toJson();

    Map<String, dynamic> update = {};
    update['Users/UID/${uid}/Note/${noteModel.keyData}'] = note;
    return FirebaseDatabase.instance.ref().update(update);
  }
}
