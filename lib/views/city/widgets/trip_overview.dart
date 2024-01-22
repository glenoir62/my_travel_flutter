import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_travel/models/trip.model.dart';

class TripOverview extends StatelessWidget {
  final VoidCallback setDate;
  final Trip mytrip;
  final String cityName;
  final double amount;


  //double get amount => 0;

  const TripOverview({super.key, required this.setDate, required this.mytrip, required this.cityName, required this.amount});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      width:
          //Platform.isAndroid
          orientation == Orientation.landscape ? size.width * 0.5 : size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            cityName,
            style: const TextStyle(
              fontSize: 25,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  mytrip.date != null
                      ? DateFormat('d/M/y').format(mytrip.date!)
                      : 'Sélectionnez une date',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: setDate,
                child: const Text('Sélectionnez une date'),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Montant / personne',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Text(
                '$amount€',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
