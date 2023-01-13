import 'dart:convert';

import 'package:http/http.dart' as http;

class CountryList {
  final List<Country> countryList;

  CountryList({this.countryList});

  factory CountryList.fromJson(Map<String, dynamic> json) {
    var countriesJson = json['result'] as List;
    List<Country> countryList =
        countriesJson.map((e) => Country.fromJson(e)).toList();
    return CountryList(countryList: countryList);
  }

  Future<CountryList> getCountries() async {
    CountryList data;
    final uri = Uri.parse('https://api.printful.com/countries');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      data = CountryList.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'getCountries error: ${response.statusCode} - ${response.reasonPhrase}');
    }
    return data;
  }
}

class Country {
  final String name;

  Country({this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    return Country(name: name);
  }
}
