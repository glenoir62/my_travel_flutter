import 'package:flutter/material.dart';
import 'package:my_travel/models/city_model.dart';
import 'package:my_travel/models/trip.model.dart';
import 'package:my_travel/providers/city_provider.dart';
import 'package:my_travel/providers/trip_provider.dart';
import 'package:my_travel/views/activity_form/activity_form_view.dart';
import 'package:my_travel/views/city/widgets/activity_list.dart';
import 'package:my_travel/views/city/widgets/trip_activity_list.dart';
import 'package:my_travel/views/city/widgets/trip_overview.dart';
import 'package:my_travel/views/home/dyma_drawer.dart';
import 'package:my_travel/views/home/home_view.dart';
import 'package:provider/provider.dart';
import '../../models/activity.model.dart';

class CityView extends StatefulWidget {
  static const String routeName = '/city';

  const CityView({super.key});

  showContext({required BuildContext context, required List<Widget> children}) {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(
        children: children,
      );
    }
  }

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView> with WidgetsBindingObserver {
  late Trip mytrip;
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
    mytrip = Trip(activities: [], date: null, city: '');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("test " + state.toString());
  }

  void toggleActivity(Activity activity) {
    setState(() {
      mytrip.activities.contains(activity)
          ? mytrip.activities.remove(activity)
          : mytrip.activities.add(activity);
    });
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void setDate() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2025),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          mytrip.date = newDate;
        });
      }
    });
  }

  double get amount {
    return mytrip.activities.fold(0.0, (prev, element) {
      return prev + element.price;
    });
  }

  void saveTrip(String cityName) async {
    final result = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Voulez-vous sauvegarder ?'),
        contentPadding: const EdgeInsets.all(20),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.pop(context, 'save');
                },
                child: const Text(
                  'Sauvegarder',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.pop(context, 'cancel');
                },
              )
            ],
          ),
        ],
      ),
    );

    if (mytrip.date == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Attention !'),
            content: const Text('Vous n avez pas entré de date'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    } else if (result == 'save') {
      // La vérification de la valeur de mounted permet
      // de s'assurer que le Context est toujours disponibles après une action asynchrone.
      if (mounted) {
        mytrip.city = cityName;
        Provider.of<TripProvider>(context, listen: false).addTrip(mytrip);
        Navigator.pushNamed(context, HomeView.routeName);
      }
    }
  }

  void deleteTripActivity(Activity activity) {
    setState(() {
      mytrip.activities.remove(activity);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final City city = ModalRoute.of(context)!.settings.arguments as City;
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);

    return Scaffold(
        appBar: AppBar(
          //leading: const Icon(Icons.chevron_left),
          title: const Text('Organisation du voyage'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(
                context,
                ActivityFormView.routeName,
                arguments: cityName,
              ),
            )
          ],
        ),
        drawer: const DymaDrawer(),
/*      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.separated(
          itemCount: widget.activities.length,
          itemBuilder: (context, index) => ActivityCard(
            activity: widget.activities[index],
          ),
          separatorBuilder: (context, index) => const Divider(
            color: Colors.blue,
            endIndent: 100,
            indent: 100,
            height: 50,
          ),
        ),
      ),*/
        body: Container(
          child: widget.showContext(
            context: context,
            children: [
              TripOverview(
                  mytrip: mytrip,
                  setDate: setDate,
                  cityName: city.name,
                  amount: amount),
              Expanded(
                child: index == 0
                    ? ActivityList(
                        activities: city.activities,
                        selectedActivities: mytrip.activities,
                        toggleActivity: toggleActivity,
                      )
                    : TripActivityList(
                        activities: mytrip.activities,
                        deleteTripActivity: deleteTripActivity),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => saveTrip(city.name),
          child: const Icon(Icons.forward),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.red,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Découverte',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stars),
              label: 'Mes activités',
            )
          ],
          onTap: switchIndex,
        ));
  }
}
