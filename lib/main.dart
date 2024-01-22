import 'package:flutter/material.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/activity_form/activity_form_view.dart';
import 'package:my_travel/views/home/home_view.dart';
import 'package:my_travel/views/city/city_view.dart';
import 'package:my_travel/views/not-found/not_found.dart';
import 'package:my_travel/views/trip/trip_view.dart';
import 'package:my_travel/views/trips/trips_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DymaTrip());
}

class DymaTrip extends StatefulWidget {
  DymaTrip({super.key});

  @override
  State<DymaTrip> createState() => _DymaTripState();
}

class _DymaTripState extends State<DymaTrip> {
  final CityProvider cityProvider = CityProvider();
  final TripProvider tripProvider = TripProvider();


  @override
  void initState() {
    cityProvider.fetchData();
    tripProvider.fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cityProvider),
        ChangeNotifierProvider.value(value: tripProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(titleTextStyle: TextStyle(fontSize: 30)),
            primarySwatch: Colors.red,
            textTheme:
                const TextTheme(bodyLarge: TextStyle(color: Colors.orange))),
        routes: {
          // Par convention en Dart, lorsque nous n'utilisons pas un argument reçu qui est obligatoire (comme pour context),
          // nous le remplaçons par _.
          '/': (context) => const HomeView(),
          CityView.routeName: (_) => const CityView(),
          TripsView.routeName: (_) => const TripsView(),
          TripView.routeName: (_) => const TripView(),
          ActivityFormView.routeName: (_) => const ActivityFormView(),
        },
        onUnknownRoute: (_) => MaterialPageRoute(
          builder: (_) => const NotFound(),
        ),
      ),
    );
  }
}

/*
class _DymaTripState extends State<DymaTrip> {

  void addTrip(Trip trip) {
    setState(() {
      trips.add((trip));
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(titleTextStyle: TextStyle(fontSize: 30)),
            primarySwatch: Colors.red,
            textTheme:
                const TextTheme(bodyLarge: TextStyle(color: Colors.orange))),
        debugShowCheckedModeBanner: false,
        //home:  Home()
        initialRoute: '/',
        routes: {
          HomeView.routeName: (context) => HomeView(cities: widget.cities),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case CityView.routeName:
              {
                return MaterialPageRoute(builder: (context) {
                  final City city = settings.arguments as City;
                  return CityView(
                    city: city,
                    addTrip: addTrip,
                  );
                });
              }
            case TripsView.routeName:
              {
                return MaterialPageRoute(builder: (context) {
                  return TripsView(trips: trips);
                });
              }
            case TripView.routeName:
              {
                return MaterialPageRoute(
                  builder: (context) {
                    String tripId =
                    (settings.arguments as Map<String, String>)['tripId']!;
                    String cityName =
                    (settings.arguments as Map<String, String>)['cityName']!;
                    return TripView(
                      trip: trips.firstWhere((trip) => trip.id == tripId),
                      city: widget.cities
                          .firstWhere((city) => city.name == cityName),
                    );
                  },
                );
              }
          }
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const NotFound());
        });
  }
}*/
