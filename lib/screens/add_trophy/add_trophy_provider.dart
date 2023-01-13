import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/achivement.dart';
import 'package:video_player/video_player.dart';

class AddTrophyProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  final String _userId = FirebaseAuth.instance.currentUser.uid;

  bool _barcodeValid = false;
  bool _canContinue = false;
  String _scanValue;
  File _photoSerialNumber;
  File _media1;
  File _media2;
  String _photoAddSerialNumberPhotoPath;
  String _media1Path;
  String _media2Path;
  String _description;
  File _eventPic;
  File _holdTrophyPic;
  VideoPlayerController _eventVideo;
  VideoPlayerController _holdVideo;
  bool _isHoldVideo = false;
  bool _isEventVideo = false;

  bool get canContinue => _canContinue;
  // TODO(REFACTORING): maybe should add "is" to name
  bool get barcodeValid => _barcodeValid;

  // TODO(REFACTORING): what this means??? Maybe should refactor
  bool get isHoldVideo => _isHoldVideo;
  // TODO(REFACTORING): what this means??? Maybe should refactor
  bool get isEventVideo => _isEventVideo;
  // TODO(REFACTORING): maybe should rename to scannedValue or other
  String get scanValue => _scanValue;
  // TODO(REFACTORING): Maybe should rename to descriptionText
  String get descriptionValue => _description;

  File get photo => _photoSerialNumber;
  // TODO(REFACTORING): make more understandble
  File get media1 => _media1;
  // TODO(REFACTORING) :make more understandble
  File get media2 => _media2;

  File get eventPic => _eventPic;

  File get holdTrophyPic => _holdTrophyPic;

  VideoPlayerController get eventVideo => _eventVideo;

  VideoPlayerController get holdVideo => _holdVideo;

  // TODO(REFACTORING): rename!!!!!!
  _continueButton() {
    if (_barcodeValid) {
      _canContinue = true;
    } else {
      _canContinue = false;
    }
    notifyListeners();
  }

  // TODO(REFACTORING): remove this if not used
  setPhotoSerialNumber(File value) {
    _photoSerialNumber = value;
  }

  setDescription(String value) {
    _description = value;
  }

  // TODO(REFACTORING) :make more understandble
  setPhotoMedia1(File value) {
    _media1 = value;
  }

  // TODO(REFACTORING) :make more understandble
  setPhotoMedia2(File value) {
    _media2 = value;
  }

  setBarcode(String value) async {
    // TODO(REFACTORING): maybe should make 12 to const variable
    if (value.length == 12) {
      // TODO(REFACTORING): make debug format
      print('ScanCode: $value');
      _barcodeValid = true;
      _scanValue = value;
    } else
      _barcodeValid = false;
    notifyListeners();
    _continueButton();
  }

  // TODO(REFACTORING): remove type!! it seems strange and unnecessary
  setEventPic(File value, bool type) {
    // TODO(REFACTORING): why this variable contains "Video"
    // but method contains Pic??????
    _isEventVideo = type;
    _eventPic = value;
    _continueButton();
  }

  // TODO(REFACTORING): remove type!! it seems strange and unnecessary
  setHoldTrophyPic(File value, bool type) {
    // TODO(REFACTORING): why this variable contains "Video"
    // but method contains Pic??????
    _isHoldVideo = type;
    _holdTrophyPic = value;
    _continueButton();
  }

  playEventVideo(VideoPlayerController controller) {
    _eventVideo = controller..initialize().then((value) => controller.play());
    notifyListeners();
  }

  playHoldTrophyVideo(VideoPlayerController controller) {
    _holdVideo = controller..initialize().then((value) => controller.play());
    notifyListeners();
  }

  disposeEventVideo() {
    _eventVideo.pause();
    _eventVideo = null;
    _isEventVideo = false;
    notifyListeners();
  }

  disposeHoldVideo() {
    holdVideo.pause();
    _holdVideo = null;
    _isHoldVideo = false;
    notifyListeners();
  }

  disposeEventPic() {
    _eventPic = null;
    notifyListeners();
  }

  disposeHoldPic() {
    _holdTrophyPic = null;
    notifyListeners();
  }

  addSerialNumberPhoto() async {
    _storage
        .ref()
        .child('/add_trophy/${basename(_photoSerialNumber.path)}')
        .putFile(_photoSerialNumber)
        .then((value) => value.ref.getDownloadURL())
        .then((value) {
      _photoAddSerialNumberPhotoPath = value;
    }).catchError((e) =>
            throw Exception('Error on addSerialNumberPhoto ${e.toString()}'));
  }

  addMedia1Photo() async {
    _storage
        .ref()
        .child('/add_trophy_media/${basename(_media1.path)}')
        .putFile(_media1)
        .then((value) => value.ref.getDownloadURL())
        .then((value) {
      _media1Path = value;
    }).catchError(
            (e) => throw Exception('Error on addMedia1Photo ${e.toString()}'));
  }

  addMedia2Photo() async {
    _storage
        .ref()
        .child('/add_trophy_media/${basename(_media2.path)}')
        .putFile(_media2)
        .then((value) => value.ref.getDownloadURL())
        .then((value) {
      _media2Path = value;
    }).catchError(
            (e) => throw Exception('Error on addMedia2Photo ${e.toString()}'));
  }

  Future<void> addTrophy() async {
    final trophies = await FirebaseFirestore.instance
        .collection('trophy')
        .where('serial', isEqualTo: _scanValue)
        .get();
    if (trophies.docs.length != 1) {
      throw Exception(
          'There is no trophy with this serial number or there are many trophies with same serial number');
    }

    Achievement addTrophy = Achievement(
      userId: _userId,
      id: _scanValue,
      medias: [_media1Path, _media2Path, _photoAddSerialNumberPhotoPath],
      description: _description,
      isVerified: false,
      decline: false,
      declineComent: '',
      declineCause: '',
      trophyId: trophies.docs.first.id,
    );
    final currentUserId = FirebaseAuth.instance.currentUser.uid;
    _firestore.collection('users').doc(currentUserId).update({
      'achievements': FieldValue.arrayUnion([addTrophy.toFirebase()]),
    }).catchError((e) => throw Exception('addTrophy Error : ${e.toString()}'));
  }
}
