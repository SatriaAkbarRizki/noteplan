import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  Future<String?> uploadImage(File? imagePath) async {
    String? linkImages;
    try {
      final String nameImage = basename(imagePath!.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('images/${nameImage}');
      final upload = storageRef.putFile(imagePath);
      final snapsot = await upload.then((v) async {
        if (v.state == TaskState.success) {
          final result = await storageRef.getDownloadURL();
          print('Succes Upload : ${result}');
          linkImages = result;
        } else {
          print('Eror get Url:${v.toString()}');
          linkImages = null;
        }
      });
    } on FirebaseException catch (e) {
      print('Eror Upload: ${e.toString()}');
    }
    return linkImages;
  }

  Future deleteImage(String? links) async {
    try {
      final url = links.toString();
      Uri uri = Uri.parse(url);
      final path = uri.path;
      String imageName = path.substring(path.lastIndexOf('/images%2F') + 9);
      final deleteRef =
          FirebaseStorage.instance.ref().child("images/${imageName}");
      await deleteRef.delete();
    } on FirebaseException catch (e) {
      print('Eror Delete: ${e.toString()}');
    }
  }
}

// Dikit lagi tinggal masukkin aja gambar ke cloud storage
