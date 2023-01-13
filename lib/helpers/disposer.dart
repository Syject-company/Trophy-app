import 'package:flutter/material.dart';

class Disposer {
  static void disposeProviders(List<ChangeNotifier> providers) {
    providers.forEach((element) {
      element.dispose();
    });
  }
}
