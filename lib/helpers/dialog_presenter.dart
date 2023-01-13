import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trophyapp/constants/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogPresenter {
  static Future<void> showNewVersionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Version'),
          content: Text('Do you want to get a new version of this app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Later'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final url = playMarketLink;
                await canLaunch(url)
                    ? await launch(url)
                    : throw 'Could not launch $url';
              },
              child: Text('Get'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showNewVersionCupertinoDialog(
      BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('New Version'),
        content: Text('New version of this app is available.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Later'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
