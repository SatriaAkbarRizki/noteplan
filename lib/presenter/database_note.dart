import 'package:firebase_database/firebase_database.dart';
import 'package:noteplan/main.dart';
import 'package:noteplan/model/note.dart';

class DatabaseNote {
  final String uid;
  List<NoteModel>? notemodelList;
  Map<String, NoteModel>? dataUser;

  DatabaseNote({required this.uid});

  get reference => FirebaseDatabase.instance.ref().child('Users/UID/$uid/Note');

  Query queryFirebase() {
    return reference;
  }

  Future saveNote(NoteModel noteModel) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('Users/UID/$uid/Note');
    databaseReference.push().set(noteModel.toJson());
  }

  Future<List<NoteModel>?> readData() async {
    notemodelList = [];
    final reference = await FirebaseDatabase.instance
        .ref()
        .child('Users/UID/${MainState.currentUid.toString()}/Note')
        .once();

    final data = reference.snapshot.value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      NoteModel noteModel = NoteModel.fromMap(key, value);
      notemodelList?.add(noteModel);
    });
    // notemodelList?.forEach((element) {
    //   print(element.keyData);
    // });
    // print('length in notemodelist: ${n otemodelList!.length}');
    return notemodelList;
  }

  Future updateData(String key, NoteModel noteModel) async {
    final note = noteModel.toJson();

    Map<String, dynamic> update = {};
    update['Users/UID/${noteModel.keyData}/Note/$key'] = note;
    return FirebaseDatabase.instance.ref().update(update);
  }
}
