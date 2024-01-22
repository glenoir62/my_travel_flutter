import 'package:flutter/material.dart';
import 'package:my_travel/models/activity.model.dart';

class TripActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function deleteTripActivity;

  const TripActivityList({super.key, required this.activities, required this.deleteTripActivity});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var activity = activities[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(activity.image!),
            ),
            title: Text(
              activity.name!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteTripActivity(activity);
                ScaffoldMessenger.of(context)
                  // Rappelez-vous que les .. en Dart permettent de chaîner des méthodes sur le même objet.
                  // En effet, en chainant des méthodes avec un . c'est sur l'objet retourné par la méthode précédente que s'exécute la méthode suivante. Or ici par exemple removeCurrentSnackBar() ne retourne rien.
                  // Grâce à ce code, nous fermons rapidement la SnackBar précédente, puis nous affichons la nouvelle.
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Activitée supprimée'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1)
                    ),
                  );
              },
            ),
          ),
        );
      },
      itemCount: activities.length,
    );
  }
}
