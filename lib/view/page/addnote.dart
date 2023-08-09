import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noteplan/model/users.dart';
import 'package:noteplan/presenter/presenter.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  Presenter? presenter;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void sendData(String name, String email, String profile_image) async {
    // Perabiki logic disini
    presenter = Presenter(uid: 'afsafsfas1216');
    final user =
        UserModel(name: name, email: email, profile_image: profile_image);
    presenter!.saveData(user);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                sendData(nameController.text, addressController.text,
                    'example images 2');
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 180),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                controller: addressController,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
