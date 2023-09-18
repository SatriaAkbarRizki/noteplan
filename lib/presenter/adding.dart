import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/model/note.dart';

class AddingNote {
  final String uid;
  List<NoteModel>? notemodelList;

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
    notemodelList!.clear();
    final reference = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/${uid}/Note')
        .once();

    final data = reference.snapshot.value as Map<dynamic, dynamic>;
    // print('data in firebase: ${data.length}');

    final convertToModel = data.map((key, value) => MapEntry(key, value));

    data.forEach((key, value) {
      NoteModel noteModel = NoteModel.fromMap(value);

      notemodelList!.add(noteModel);
    });

    // print('length in notemodelist: ${notemodelList!.length}');
    return notemodelList!;
  }

  Future updateData(String uid, NoteModel noteModel) async {
    final note = noteModel.toJson();

    Map<String, dynamic> update = {};
    update['Users/UID/${uid}/Note'] = note;
    return FirebaseDatabase.instance.ref().update(update);
  }
}
