import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/model/user.dart' as trophy_user;
import 'package:trophyapp/discourse/discourse.dart' as discourse;

class AppProvider with ChangeNotifier {
  AppProvider() {
    _listener = (user) {
      if (user == null) {
        _isLooggedIn = false;
      } else {
        _isLooggedIn = true;
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((snapshot) {
          if (snapshot.data() != null) {
            final user = trophy_user.User.fromFirebase(snapshot.data());
            discourse.Discourse().setCurrentUser(userId: user.discourseId);
          }
        });
      }

      notifyListeners();
    };
    authStatus();
  }

  void Function(User) _listener;

  bool _isLooggedIn = false;
  StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  bool get isLoggedIn => _isLooggedIn;

  User get currentUser => FirebaseAuth.instance.currentUser;

  authStatus() async {
    _subscription = FirebaseAuth.instance.authStateChanges().listen(
      _listener,
      onDone: () {
        print('AuthStateChanges Done!');
      },
      onError: (error, stackTrace) {
        print('AuthStateChanges Error: $error\n$stackTrace');
      },
    );
  }
}
