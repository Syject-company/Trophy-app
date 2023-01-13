import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trophyapp/model/level.dart';

class MySuccessProvider with ChangeNotifier {
  Future<List<Level>> getLvlInfo() async {
    final QuerySnapshot response = await FirebaseFirestore.instance
        .collection('level')
        .orderBy('id')
        .get();
    List<Level> levelList =
        response.docs.map((e) => Level.fromFirebase(e.data())).toList();
    return levelList;
  }
}
