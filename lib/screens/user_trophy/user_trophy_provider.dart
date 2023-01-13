import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:trophyapp/model/3d_object.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trophyapp/model/achivement.dart';
import 'package:trophyapp/model/trophy.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class UserTrophyProvider with ChangeNotifier {
  final fbStorage = storage.FirebaseStorage.instanceFor();
  bool pictureView = true;
  bool isVerified = false;
  bool inaprovedContent = false;
  bool standartsContent = false;
  VolumeObjectResponse _objectDescriptor;
  String object;

  String trophyImage;

  VolumeObjectResponse get objectDescriptor => _objectDescriptor;

  Future<Trophy> getTrophyById() async {
    CollectionReference trophyCollection =
        FirebaseFirestore.instance.collection('trophy');
    var trophy = await trophyCollection
        .doc('TvMz4yQQKTFrcQ0atE7d')
        .get()
        .then((trophy) => Trophy.fromFirebase(trophy.data()));
    return trophy;
  }

  Future<void> get3dObjectWithTexture(Trophy trophy) async {
    final String trophyName = trophy.name.toLowerCase();
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = documentDirectory.path + '/objects/$trophyName';
    final File downloadToFile = File('$path/trophyName.zip');
    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
      _objectDescriptor =
          VolumeObjectResponse(objPath: '$path/$trophyName.obj');
    } else {
      final objectDir =
          Directory(documentDirectory.path + '/objects/$trophyName');
      await objectDir.create(recursive: true);
      await fbStorage
          .ref('irla_3d/$trophyName/$trophyName.zip')
          .writeToFile(downloadToFile)
          .catchError((e) => throw Exception(
              'Trophy details error, on download zipFile from FireBase Storage ${e.toString()}'));
      await ZipFile.extractToDirectory(
              zipFile: downloadToFile, destinationDir: Directory(path))
          .catchError((e) => print(e));
      _objectDescriptor =
          VolumeObjectResponse(objPath: '$path/$trophyName.obj');
    }
    notifyListeners();
  }

  changeView() {
    pictureView = !pictureView;
    notifyListeners();
  }

  verifyButton(Achievement achievement) async {
    final QuerySnapshot achievementDocId = await FirebaseFirestore.instance
        .collection('achievement')
        .where('id', isEqualTo: achievement.id)
        .get();

    if (achievement.isVerified == true) {
      await FirebaseFirestore.instance
          .collection('achievement')
          .doc(achievementDocId.docs.first.id)
          .update({'isVerified': false}).then((value) => print('False set'));
      notifyListeners();
    } else {
      await FirebaseFirestore.instance
          .collection('achievement')
          .doc(achievementDocId.docs.first.id)
          .update({'isVerified': true}).then((value) => print('True set'));
      notifyListeners();
    }
    isVerified = !isVerified;
    notifyListeners();
  }

  declineButton(Achievement achievement) async {
    final QuerySnapshot achievementDocId = await FirebaseFirestore.instance
        .collection('achievement')
        .where('id', isEqualTo: achievement.id)
        .get();

    await FirebaseFirestore.instance
        .collection('achievement')
        .doc(achievementDocId.docs.first.id)
        .delete()
        .then((value) => print('Delete complete'));
    notifyListeners();
  }

  inaprovedCheckbox() {
    inaprovedContent = !inaprovedContent;
    notifyListeners();
  }

  standartsCheckbox() {
    standartsContent = !standartsContent;
    notifyListeners();
  }
}
