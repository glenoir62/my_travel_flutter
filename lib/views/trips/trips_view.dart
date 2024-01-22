import 'package:flutter/material.dart';
import 'package:my_travel/models/trip.model.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/home/dyma_drawer.dart';
import 'package:my_travel/views/home/widgets/dyma_loader.dart';
import 'package:my_travel/views/trips/widgets/trip_list.dart';
import 'package:provider/provider.dart';

class TripsView extends StatelessWidget {
  static const String routeName = '/trips';

  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Trip> trips = Provider.of<TripProvider>(context).trips;
    TripProvider tripProvider = Provider.of<TripProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes voyages'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'A venir',
            ),
            Tab(
              text: 'Passés',
            )
          ]),
        ),
        drawer: const DymaDrawer(),
        body: tripProvider.isLoading == false
            ? tripProvider.trips.isNotEmpty
                ? TabBarView(
                    children: <Widget>[
                      TripList(
                        trips: trips
                            .where((trip) => trip.date != null)
                            .where(
                                (trip) => DateTime.now().isBefore(trip.date!))
                            .toList(),
                      ),
                      TripList(
                        trips: trips
                            .where((trip) => trip.date != null)
                            .where((trip) => DateTime.now().isAfter(trip.date!))
                            .toList(),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    child: const Text('Aucun voyage pour le moment'),
                  )
            : const DymaLoader(),
      ),
    );
  }
}
