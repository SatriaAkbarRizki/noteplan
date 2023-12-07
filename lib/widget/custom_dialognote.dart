import 'package:flutter/material.dart';
import 'package:noteplan/model/note.dart';

class CustomDialogNote extends StatelessWidget {
  final NoteModel noteModel;

  final double padding = 20, avatarRadius = 45;
  CustomDialogNote({required this.noteModel, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Container(
            height: 180,
            padding: EdgeInsets.only(
                left: padding,
                top: avatarRadius,
                right: padding,
                bottom: padding),
            margin: EdgeInsets.only(top: padding),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(171, 0, 0, 0),
                      offset: Offset(15, 20),
                      blurRadius: 5),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    noteModel.date,
                    style: const TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    noteModel.time,
                    style: const TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
