import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/3d_object.dart';
import 'package:trophyapp/model/trophy.dart';

class TrophyDetailProvider with ChangeNotifier {
  // final _firestore = FirebaseFirestore.instance;

  final fbStorage = storage.FirebaseStorage.instanceFor();
  bool _pictureView = true;
  bool _isTracked = false;
  VolumeObjectResponse _objectDescriptor;
  String object;

  VolumeObjectResponse get objectDescriptor => _objectDescriptor;

  bool get pictureView => _pictureView;
  bool get isTracked => _isTracked;

  Future<String> downloadImage(String url) async {
    var response = await http.get(Uri.parse(url));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePath = documentDirectory.path + "/images";
    var fullPath = documentDirectory.path + '/images/pic.jpg';
    await Directory(filePath).create(recursive: true);
    File file = File(fullPath);
    file.writeAsBytesSync(response.bodyBytes);
    return fullPath;
  }

//Предложить вариант удаления директории после закрытия приложения или экрана.
  Future<void> get3dObjectWithTexture(Trophy trophy) async {
    final String trophyName = trophy.name.toLowerCase();
    final documentDirectory = await getApplicationDocumentsDirectory();
    //final String objectLink = trophy.model;
    final path = documentDirectory.path + '/objects/$trophyName';
    // final zipFile = '$path/$trophyName.zip';
    final File downloadToFile = File('$path/trophyName.zip');
    // await Directory(path).delete(recursive: true);

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

      // await Dio(BaseOptions(baseUrl: trophy.model)).download('', zipFile).catchError((e) => print(e));
      // await ZipFile.extractToDirectory(zipFile: File(zipFile), destinationDir: Directory(path))
      //     .catchError((e) => print(e));

      //var wasd = objectDir.listSync(recursive: true);

    }

    notifyListeners();
  }

  trackTrophy() {
    _isTracked = !_isTracked;
    notifyListeners();
  }

  changeView() {
    _pictureView = !_pictureView;
    notifyListeners();
  }
}
