import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';
import 'trip_activity_list.dart';

class TripActivities extends StatelessWidget {
  final String tripId;

  const TripActivities({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).splashColor,
            child: TabBar(
              indicatorColor: Colors.blue[500],
              labelColor: Colors.black,
              tabs: const <Widget>[
                Tab(
                  text: 'En cours',
                ),
                Tab(
                  text: 'Terminées',
                )
              ],
            ),
          ),
          SizedBox(
            height: 600,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                TripActivityList(
                  tripId: tripId,
                  filter: ActivityStatus.ongoing,
                ),
                TripActivityList(
                  tripId: tripId,
                  filter: ActivityStatus.done,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
