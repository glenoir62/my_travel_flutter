import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/views/city/widgets/activity_card.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function toggleActivity;
  final List<Activity> selectedActivities;

  const ActivityList({super.key,
    required this.activities,
    required this.selectedActivities,
    required this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: activities
          .map(
            (activity) => ActivityCard(
          activity: activity,
          isSelected: selectedActivities.contains(activity),
          toggleActivity: () => toggleActivity(activity),
        ),
      )
          .toList(),
    );
  }
}
