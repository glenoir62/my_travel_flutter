import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/trip.model.dart';
import 'package:http/http.dart' as http;

class TripProvider extends ChangeNotifier {
  List<Trip> _trips = [];
  final String host = 'localhost';
  bool isLoading = false;

  UnmodifiableListView<Trip> get trips => UnmodifiableListView(_trips);

  /**
   * Nous modifions la méthode addTrip() pour effectuer la requête HTTP POST.
   * Dans le body de notre requête nous envoyons le Trip que nous transformons d'abord en format compatible JSON avec notre méthode toJson(),
   * puis que nous encodons en JSON avec json.encode().
   */
  Future<void> addTrip(Trip trip) async {
    try {
      print(trip.toJson());
      http.Response response = await http.post(
        Uri.http(host, '/api/trip'),
        body: json.encode(
          trip.toJson(),
        ),
        headers: {'Content-type': 'application/json'},
      );
      print(response.body);
      print(response.statusCode);

      print(response.reasonPhrase);
      print(response.request);


      if (response.statusCode == 200) {
        print(response.body);

        _trips.add(
          Trip.fromJson(
            json.decode(response.body),
          ),
        );
        // a méthode notifyListeners() permet d'appeler tous les listeners enregistrés pour leur indiquer que la valeur a changé
        // et que les Widgets qui utilisent le Provider doivent rebuild.
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Trip getById(String id) {
    return trips.firstWhere((trip) => trip.id == id);
  }

  Future<void> updateTrip(Trip trip, String activityId) async {
    try {
      Activity activity =
      trip.activities.firstWhere((activity) => activity.id == activityId);
      activity.status = ActivityStatus.done;
      http.Response response = await http.put(
          Uri.http(host, '/api/trip'),
          body: json.encode(
            trip.toJson(),
          ),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode != 200) {
        activity.status = ActivityStatus.ongoing;
        throw const HttpException('error');
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response response = await http.get(Uri.http(host, '/api/trips'));
      if (response.statusCode == 200) {
        _trips = (json.decode(response.body) as List)
            .map((tripJson) => Trip.fromJson(tripJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

}