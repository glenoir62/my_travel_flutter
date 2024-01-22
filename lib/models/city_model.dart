import 'package:my_travel/models/activity.model.dart';

class City {
  String? id;
  String image;
  String name;
  List<Activity> activities;
  City({
    required this.id,
    required this.image,
    required this.name,
    required this.activities,
  });
  City.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        image = json['image'],
        name = json['name'],
        activities = (json['activities'] as List)
            .map((activityJson) => Activity.fromJson(activityJson))
            .toList();
}