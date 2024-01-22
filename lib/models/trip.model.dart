import 'package:my_travel/models/activity.model.dart';
import 'package:http/http.dart' as http;

class Trip {
  String? id;
  String city;
  List<Activity> activities;
  DateTime? date;

  Trip({
    this.id,
    required this.city,
    required this.activities,
    this.date,

  });

  Trip.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        city = json['city'],
        date = DateTime.parse(json['date']),
        activities = (json['activities'] as List)
            .map(
              (activityJson) => Activity.fromJson(activityJson),
        )
            .toList();

  Map<String, dynamic> toJson() {
    if (id != null) {
      return {
        '_id': id,
        'city': city,
        'date': date!.toIso8601String(),
        'activities': activities
            .map(
              (activity) => activity.toJson(),
            )
            .toList()
      };
    } else {
      return {
        'city': city,
        'date': date!.toIso8601String(),
        'activities': activities
            .map(
              (activity) => activity.toJson(),
            )
            .toList(),
      };
    }
  }
}
