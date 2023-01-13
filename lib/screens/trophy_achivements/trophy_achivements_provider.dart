import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/trophy.dart';

class TrophyAchivementsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int sort = 0;
  List<Trophy> _trophies;

  Future<List<Trophy>> getTrophy() async {
    var snapshot = await _firestore.collection('trophy').get();
    _trophies =
        snapshot.docs.map((e) => Trophy.fromFirebase(e.data())).toList();
    return _trophies;
  }
  // final List<TrophyOld> mockedTrophies = [
  //   TrophyOld(name: "Trophy 0", completeDays: 128, trackDays: 2, imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.verified),
  //   TrophyOld(name: "Trophy 1", completeDays: 64, trackDays: 4, imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.unverified),
  //   TrophyOld(name: "Trophy 2", completeDays: 32, trackDays: 8,imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.unverified),
  //   TrophyOld(name: "Trophy 3", completeDays: 16, trackDays: 16, imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.verified),
  //   TrophyOld(name: "Trophy 4", completeDays: 8, trackDays: 32, imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.verified),
  //   TrophyOld(name: "Trophy 5", completeDays: 4, trackDays: 64, imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.unverified),
  //   TrophyOld(name: "Trophy 6", completeDays: 2, trackDays: 128, imageURLs: ['',''], imageURL: 'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',trophyType: TrophyType.verified),
  // ];

  sortOption(int val) {
    sort = val;
    notifyListeners();
  }
}
