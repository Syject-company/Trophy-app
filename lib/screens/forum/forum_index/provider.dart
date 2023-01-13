import 'package:flutter/cupertino.dart';
import 'package:trophyapp/discourse/discourse.dart';

class ForumIndexProvider with ChangeNotifier {
  Category _category;
  Category _subcategory;
  bool _isFiltered = false;
  String searchQuery;
  String searchError = '';
  bool searchValid = false;

  Category get category => _category;
  set category(Category category) {
    _category = category;
    notifyListeners();
  }

  Category get subcategory => _subcategory;
  set subcategory(Category subcategory) {
    _subcategory = subcategory;
    notifyListeners();
  }

  bool get isFiltered => _isFiltered;
  void applyFilter() {
    _isFiltered = true;
    notifyListeners();
  }

  void removeFilter() {
    _category = null;
    _subcategory = null;
    _isFiltered = false;
    notifyListeners();
  }

  validateSearch(String val) {
    if (val.length >= 3) {
      searchValid = true;
      searchError = '';
    } else {
      searchValid = false;
      searchError = 'Search query must be at least 3 characters';
    }
    searchQuery = val;
    notifyListeners();
  }

  String getLastposted(DateTime lastpost) {
    final now = DateTime.now().toUtc();
    Duration difference = now.difference(lastpost);
    if (difference.inDays >= 365)
      return '${(difference.inDays / 365).round()} yr';
    else if (difference.inDays >= 1)
      return '${difference.inDays} d';
    else if (difference.inHours >= 1)
      return '${difference.inHours} h';
    else if (difference.inMinutes >= 1)
      return '${difference.inMinutes} m';
    else
      return '${difference.inSeconds} s';
  }
}
