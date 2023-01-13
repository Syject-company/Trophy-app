import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trophyapp/discourse/discourse.dart' hide User;
import 'package:trophyapp/model/user.dart' as usr;
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Client {
  static final instance = Client._internal();
  factory Client() => instance;
  Client._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future signUpWithCredentials(String email, String password, String username,
      String country, String state, String city, String image) async {
    String imageUrl;

    User firebaseAuthUser;
    bool isFirestoreUserCreated = false;
    bool userExists = false;
    bool wasDiscourseUserCreated = false;

    try {
      try {
        final discourseUser = await Discourse().getUserByEmail(email: email);
        if (discourseUser.id <= 0) {
          throw 'No user';
        } else {
          await Discourse().setCurrentUser(userId: discourseUser.id);
          userExists = true;
        }
      } catch (e) {
        print('Error when get Discourse user by email!!');
      }

      if (!userExists) {
        await Discourse().createCurrentUser(
          email: email,
          password: password,
          username: username,
          name: username,
          active: true,
        );
        wasDiscourseUserCreated = true;
        await Discourse().updateAvatarForCurrentUser(filePath: image);
      }

      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        firebaseAuthUser = result.user;
        final ref = FirebaseStorage.instance.ref();
        final imageBasename = basename(image);
        final child = ref.child('/userAvatars/$imageBasename');
        final task = await child.putFile(File(image));
        final url = await task.ref.getDownloadURL();
        imageUrl = url;
        final user = usr.User(
            achievements: [],
            id: result.user.uid,
            discourseId: Discourse().currentUserId,
            isVerified: false,
            // TODO(REFACTORING):make more understandble
            type: 0,
            email: email,
            name: username,
            country: country,
            state: state,
            city: city,
            point: 10,
            avatar: imageUrl);
        await _firestore
            .collection('users')
            .doc(result.user.uid)
            .set(user.toFirebase());
        isFirestoreUserCreated = true;

        final storage = new FlutterSecureStorage();

        final options =
            IOSOptions(accessibility: IOSAccessibility.first_unlock);
        await storage.write(key: 'login', value: email, iOptions: options);
        await storage.write(
            key: 'password', value: password, iOptions: options);

        return result.user;
      } else {
        throw Exception('${result.toString()} ${StackTrace.current}');
      }
    } catch (error) {
      print('DEBUG SIGN UP METHOD: $error ${StackTrace.current}');
      if (wasDiscourseUserCreated) {
        await Discourse().deleteCurrentUser();
      }
      if (firebaseAuthUser != null) {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser.delete();
        }
        await logout();
      }
      if (isFirestoreUserCreated) {
        await _firestore.collection('users').doc(firebaseAuthUser.uid).delete();
      }

      return Future.error(
        error,
        StackTrace.current,
      );
    }
  }

  Future<usr.User> signInWithCredentials(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        final userSnapshot =
            await _firestore.collection('User').doc(result.user.uid).get();
        final storage = new FlutterSecureStorage();

        final options =
            IOSOptions(accessibility: IOSAccessibility.first_unlock);
        await storage.write(key: 'login', value: email, iOptions: options);
        await storage.write(
            key: 'password', value: password, iOptions: options);

        return usr.User.fromFirebase(userSnapshot.data());
      } else {
        throw "There are no user with this credentials.";
      }
    } on Exception catch (error) {
      throw error;
    }
  }

  Future<usr.User> getFacebookUser() async {
    try {
      await _signInFacebook();

      final token = (await FacebookAuth.instance.accessToken).token;

      final user = await _getFacebookUserWithToken(token);
      return user;
    } catch (e) {
      await logout();
      // TODO(REFACTORING): make debug format
      print('$e: ${StackTrace.current}');
      return Future.error(e, StackTrace.current);
    }
  }

  Future<usr.User> signUpWithFacebook(
      String email,
      String username,
      String discoursePassword,
      String country,
      String state,
      String city,
      String imageUrl,
      String imageLocalPath) async {
    User firebaseAuthUser;
    bool isFirestoreUserCreated = false;
    bool wasDiscourseUserCreated = false;
    try {
      if (await canUserSignInWithFacebook(email)) {
        throw Exception('User with this email already exists');
      }
      final token = (await FacebookAuth.instance.accessToken).token;
      final facebookCredential = FacebookAuthProvider.credential(token);
      final firebaseAuthCredential =
          await _firebaseAuth.signInWithCredential(facebookCredential);

      firebaseAuthUser = firebaseAuthCredential.user;
      if (firebaseAuthCredential.user != null) {
        try {
          final discourseUser = await Discourse().getUserByEmail(email: email);
          if (discourseUser.id <= 0) {
            throw 'No user';
          } else {
            await Discourse().setCurrentUser(userId: discourseUser.id);
          }
        } catch (e) {
          await Discourse().createCurrentUser(
            email: email,
            password: discoursePassword,
            username: username,
            name: username,
            active: true,
          );
          wasDiscourseUserCreated = true;
          await Discourse()
              .updateAvatarForCurrentUser(filePath: imageLocalPath);
        }

        final user = usr.User(
            achievements: [],
            id: firebaseAuthCredential.user.uid,
            discourseId: Discourse().currentUserId,
            isVerified: false,
            // TODO(REFACTORING):make more understandable
            type: 1,
            email: email,
            name: username,
            country: country,
            state: state,
            city: city,
            point: 10,
            avatar: imageUrl);
        await _firestore
            .collection('users')
            .doc(firebaseAuthCredential.user.uid)
            .set(user.toFirebase());
        isFirestoreUserCreated = true;

        return user;
      } else {
        throw firebaseAuthCredential.toString();
      }
    } catch (e) {
      if (wasDiscourseUserCreated) {
        await Discourse().deleteCurrentUser();
      }
      if (firebaseAuthUser != null) {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser.delete();
        }
        await FirebaseAuth.instance.signOut();
      }
      if (isFirestoreUserCreated) {
        await _firestore.collection('users').doc(firebaseAuthUser.uid).delete();
      }
      return Future.error(e, StackTrace.current);
    }
  }

  Future<usr.User> _getFacebookUserWithToken(String token) async {
    final uri = Uri(
      scheme: 'https',
      host: 'graph.facebook.com',
      path: '/v2.12/me',
      queryParameters: {
        // TODO: add all needed fields
        'fields': 'name,email,picture.type(large)',
        'access_token': token,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final profile = json.decode(response.body);
      // TODO: initialize a user
      return usr.User(
        achievements: [],
        isVerified: false,

        // TODO(REFACTORING): make more understandable
        type: 1,
        email: profile['email'],
        name: profile['name'],
        point: 0,
        avatar: profile['picture']['data']['url'],
      );
    } else {
      throw Exception('When get facebook user email by token $token: response: '
          '${response.body} phrase: ${response.reasonPhrase}');
    }
  }

  // TODO(REFACTORING): methods for facebook login below  can be packed into
  // class for example LoginWithFacebook
  Future<usr.User> signInWithFacebook() async {
    try {
      final user = await getFacebookUser();

      if (await canUserSignInWithFacebook(user.email)) {
        return await _signInFirebaseWithFacebookToken();
      } else {
        FacebookAuth.instance.logOut();
        throw Exception('User can not sign in with Facebook.');
      }
    } catch (e) {
      FacebookAuth.instance.logOut();
      return Future.error(e, StackTrace.current);
    }
  }

  Future<void> _signInFacebook() async {
    if ((await FacebookAuth.instance.accessToken) != null) return;

    final permissions = ['email'];
    final loginResult = await FacebookAuth.instance.login(
      permissions: permissions,
      loginBehavior: LoginBehavior.nativeOnly,
    );

    final status = loginResult.status;
    if (status == LoginStatus.cancelled) {
      throw Exception('Facebook login was cancelled by user.');
    } else if (status == LoginStatus.failed) {
      throw Exception('Facebook login error: ${loginResult.message}');
    } else if (status == LoginStatus.operationInProgress) {
      throw Exception(
          'Unexpected status: facebook login operation is in progress');
    }
  }

  Future<bool> canUserSignInWithFacebook(String email) async {
    final signInMethod = 'facebook.com';
    final signInMethods = await _firebaseAuth
        .fetchSignInMethodsForEmail(email)
        .timeout(Duration(minutes: 1));

    return signInMethods.contains(signInMethod);
  }

  Future<usr.User> _signInFirebaseWithFacebookToken() async {
    final token = (await FacebookAuth.instance.accessToken).token;
    final facebookCredential = FacebookAuthProvider.credential(token);
    final firebaseAuthCredential =
        await _firebaseAuth.signInWithCredential(facebookCredential);

    if (firebaseAuthCredential.user != null) {
      final userId = firebaseAuthCredential.user.uid;
      final snapshot = await _firestore.collection('users').doc(userId).get();

      return usr.User.fromFirebase(snapshot.data());
    } else {
      throw "There are no user with this credentials.";
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw error;
    }
  }

  static Future changePassword(String newPassword) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    currentUser.updatePassword(newPassword);
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await FacebookAuth.instance.logOut();
  }
}
