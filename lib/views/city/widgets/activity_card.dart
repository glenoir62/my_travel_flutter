import 'package:flutter/material.dart';
import '../../../../models/activity.model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isSelected;
  final VoidCallback toggleActivity;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.isSelected,
    required this.toggleActivity,
  });

/*  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(activity.image),
      ),
      title: Text(activity.name),
      subtitle: Text(activity.city),
      contentPadding: const EdgeInsets.all(0),
      trailing: Checkbox(
        value: true,
        tristate: true,
        onChanged: (e) => {},
        activeColor: Colors.black,
        checkColor: Colors.red,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Ink.image(
            image: NetworkImage(activity.image!),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: toggleActivity,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (isSelected)
                        const Icon(
                          Icons.check,
                          size: 40,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          activity.name!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
