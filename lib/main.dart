import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:trophyapp/helpers/handling_notifications.dart';
import 'package:trophyapp/screens/loading_screen/loading_screen.dart';
import 'package:trophyapp/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/services.dart';
import 'package:trophyapp/client/app_provider.dart';
import 'package:trophyapp/screens/tab_controller.dart';
import 'package:trophyapp/screens/trophy_tab/trophy_tab_provider.dart';
import 'package:trophyapp/helpers/dialog_presenter.dart';

void main() {
  runApp(
    MaterialApp(
      color: Colors.white,
      title: 'IRLAverse',
      home: Irla(),
    ),
  );
}

class Irla extends StatefulWidget {
  @override
  _IrlaState createState() => _IrlaState();
}

class _IrlaState extends State<Irla> {
  final bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    var androidInitialize = AndroidInitializationSettings('ic_launcher');
    var iOSInitialize = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        DialogPresenter.showNewVersionCupertinoDialog(context);
      },
    );

    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    final localNotificationPlugin = FlutterLocalNotificationsPlugin();
    localNotificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: handleSelectedNotification,
    );

    FirebaseMessaging.onMessage.listen((message) {
      showNotification(localNotificationPlugin, message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      DialogPresenter.showNewVersionDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return FutureBuilder(
      future: Future.delayed(
          Duration(seconds: 2),
          () => Firebase.initializeApp().then((_) {
                // this need for correct work listeners
                // some s
                //ituation was described in this issue:
                // https://github.com/FirebaseExtended/flutterfire/issues/6011
                FirebaseMessaging.instance.getToken().then((readyToken) {
                  print('Token of this device is $readyToken');
                });

                // Only for iOS
                FirebaseMessaging.instance.requestPermission(
                  alert: true,
                  announcement: false,
                  badge: true,
                  carPlay: false,
                  criticalAlert: false,
                  provisional: false,
                  sound: true,
                );
              })),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return TrophyApp();
        if (snapshot.hasError) return Text(snapshot.error);
        return LoadingScreen();
      },
    );
  }

  @override
  void dispose() {
    getApplicationDocumentsDirectory().then((value) => value.delete());

    /// для чего это метод? есть идея, что на IOS будет крашиться в этом месте
    super.dispose();
  }
}

class TrophyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      builder: (context, widget) {
        final provider = Provider.of<AppProvider>(context);

        /// получаем экземпляр класса
        return Container(
          child: provider.isLoggedIn
              ? ChangeNotifierProvider(
                  create: (_) => TrophyTabProvider(),
                  child: TrophyTabController(
                    userId: provider.currentUser.uid,
                  ))
              : SignInScreen(),
        );
      },
    );
  }
}
