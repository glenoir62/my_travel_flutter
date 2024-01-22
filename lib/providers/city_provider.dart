import 'dart:collection';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_travel/models/activity.model.dart';
import '../models/city_model.dart';
import 'package:http/http.dart' as http;

/**
 * Un ChangeNotifierProvider permet d'écouter un ChangeNotifier et de l'exposer à l'arbre des Widgets descendants.
 * Il entraînera un rebuild des Widgets utilisant ce Provider lorsque la méthode notifyListeners() sera appelée.
 */
class CityProvider extends ChangeNotifier {
  final String host = 'localhost';
  List<City> _cities = [];
  bool isLoading = false;

  // La classe UnmodifiableListView permet, comme son nom l'indique, de créer une vue non modifiable d'une liste.
  // Ici, dans notre Provider, nous ne souhaitons pas que la liste des villes soit modifiables.
  // Pour permettre de s'en assurer, nous passons la propriété _cities en privé.
  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) =>
              city.name.toLowerCase().startsWith(
                filter.toLowerCase(),
              ),
        )
            .toList(),
      );

  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response response = await http.get(Uri.http(host, '/api/cities'));
      if (response.statusCode == 200) {
        _cities = (json.decode(response.body) as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      print("addActivityToCity");

      String cityId = getCityByName(newActivity.city).id!;
      http.Response response = await http.post(
        Uri.http(host, '/api/city/$cityId/activity'),
        headers: {'Content-type': 'application/json'},
        body: json.encode(
          newActivity.toJson(),
        ),
      );
      print(response.statusCode);
      print(response.reasonPhrase);
      print(response.body);

      if (response.statusCode == 200) {
        int index = _cities.indexWhere((city) => city.id == cityId);
        _cities[index] = City.fromJson(
          json.decode(response.body),
        );
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> verifyIfActivityNameIsUnique(String cityName,
      String activityName) async {
    try {
      City city = getCityByName(cityName);
      http.Response response = await http
          .get(Uri.http(
          host, '/api/city/${city.id}/activities/verify/$activityName'));
      if (response.statusCode != 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<String> uploadImage(File pickedImage) async {
    try {
      var request = http.MultipartRequest(
          "POST",
          Uri.http(host, '/api/activity/image')
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'activity',
          pickedImage.readAsBytesSync(),
          filename: basename(pickedImage.path),
          contentType: MediaType("multipart", "form-data"),
        ),
      );
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return json.decode(responseData);
      } else {
        throw 'error';
      }
    } catch (e) {
      rethrow;
    }
  }
}