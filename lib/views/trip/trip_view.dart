import 'package:flutter/material.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/models/trip.model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/trip/widgets/trip_city_bar.dart';
import 'package:my_travel/views/trip/widgets/trip_activities.dart';
import 'package:my_travel/views/trip/widgets/trip_weather.dart';
import 'package:provider/provider.dart';

class TripView extends StatefulWidget {

  static const String routeName = '/trip';

  const TripView({super.key});

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {

  @override
  Widget build(BuildContext context) {
    final String cityName = (ModalRoute.of(context)!.settings.arguments
    as Map<String, String>)['cityName']!;
    final String tripId = (ModalRoute.of(context)!.settings.arguments
    as Map<String, String>)['tripId']!;
    final City city = Provider.of<CityProvider>(context, listen: false).getCityByName(cityName);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TripCityBar(
              city: city,
            ),
            TripWeather(cityName : cityName),
            TripActivities(tripId: tripId)
          ],
        ),
      ),
    );
  }
}
