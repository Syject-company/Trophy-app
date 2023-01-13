import 'dart:convert';

import 'package:http/http.dart' as http;

class Geography {
  static const Geography _instanse = Geography._internal();

  static const _defaultHost = 'countriesnow.space';

  const Geography._internal();

  factory Geography() => _instanse;

  Future<List<Country>> getCountries() async {
    final uri = Uri(
      scheme: 'https',
      host: _defaultHost,
      path: '/api/v0.1/countries/positions',
    );


    

    http.Response response;
    try {
      response = await http.get(uri);
    } catch (e) {
      throw GeographyException(
          'Error when proccess GET request: ${e.toString()}',
          'Connection error. Try reload.',
          StackTrace.current);
    }

    if (response.statusCode != 200) {
      throw GeographyException(
          'Error in response after proccess GET request: ${response.statusCode}:${response.reasonPhrase}:${response.body}',
          'Connection error. Try reload.',
          StackTrace.current);
    }

    final body = jsonDecode(response.body);
    final isThereError = body['error'];
    if (isThereError) {
      throw GeographyException(
        'Error when get list of countreis: ${body['msg']}',
        body['msg'],
        StackTrace.current,
      );
    }

    List jsonCountries = body['data'];
    List countries = jsonCountries.map<Country>((json) {
      return Country.fromJson(json);
    }).toList();

    return countries;
  }

  Future<List<State>> getStates(String country) async {
    final uri = Uri(
      scheme: 'https',
      host: _defaultHost,
      path: '/api/v0.1/countries/states',
    );

    final Map<String, dynamic> raw = {
      'country': country,
    };

    http.Response response;
    try {
      response = await http.post(uri, body: raw);
    } catch (e) {
      throw GeographyException(
          'Error when proccess POST request: ${e.toString()}',
          'Connection error. Try reload.',
          StackTrace.current);
    }

    if (response.statusCode != 200) {
      throw GeographyException(
          'Error in response after proccess POST request: ${response.statusCode}:${response.reasonPhrase}:${response.body}',
          'Connection error. Try reload.',
          StackTrace.current);
    }

    final body = jsonDecode(response.body);
    final isThereError = body['error'];
    if (isThereError) {
      throw GeographyException(
        'Error when get states of Country: ${body['msg']}',
        body['msg'],
        StackTrace.current,
      );
    }

    List jsonStates = body['data']['states'];
    List states = jsonStates.map<State>((json) {
      return State.fromJson(json);
    }).toList();

    return states;
  }

  Future<List<City>> getCities(String country, String state) async {
    final uri = Uri(
      scheme: 'https',
      host: _defaultHost,
      path: '/api/v0.1/countries/state/cities',
    );

    final Map<String, dynamic> raw = {
      'country': country,
      'state': state,
    };

    http.Response response;
    try {
      response = await http.post(uri, body: raw);
    } catch (e) {
      throw GeographyException(
          'Error when proccess POST request: ${e.toString()}',
          'Connection error. Try reload.',
          StackTrace.current);
    }

    if (response.statusCode != 200) {
      throw GeographyException(
          'Error in response after proccess POST request: ${response.statusCode}:${response.reasonPhrase}:${response.body}',
          'Connection error. Try reload.',
          StackTrace.current);
    }

    final body = jsonDecode(response.body);
    final isThereError = body['error'];
    if (isThereError) {
      throw GeographyException(
        'Error when get cities of state: ${body['msg']}',
        body['msg'],
        StackTrace.current,
      );
    }

    List jsonCities = body['data'];
    List cities = jsonCities.map<City>((jsonName) {
      return City(name: jsonName);
    }).toList();

    return cities;
  }
}

class Country {
  final String name;
  final double longitude;
  final double latitude;

  Country({this.name, this.longitude, this.latitude});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      longitude: _toDouble(json['long']),
      latitude: _toDouble(json['lat']),
    );
  }

  static double _toDouble(dynamic number) {
    if (number is String) {
      return double.parse(number);
    } else if (number is int) {
      return number.toDouble();
    } else if (number is double) {
      return number;
    } else {
      throw Exception(
          'Number is not one of String, int, double types: $number');
    }
  }
}

class State {
  String name;
  String stateCode;

  State({this.name, this.stateCode});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      name: json['name'],
      stateCode: json['state_code'],
    );
  }
}

class City {
  final String name;

  City({this.name});
}

class GeographyException implements Exception {
  final String message;
  final String userFriendlyMessage;
  final StackTrace stackTrace;

  GeographyException(this.message, this.userFriendlyMessage, this.stackTrace);
}
