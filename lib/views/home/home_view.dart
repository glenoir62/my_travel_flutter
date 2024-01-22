import 'package:flutter/material.dart';
import 'package:my_travel/views/home/dyma_drawer.dart';
import 'package:provider/provider.dart';
import '../../providers/city_provider.dart';
import '../../models/city_model.dart';
import 'widgets/city_card.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';

  const HomeView({super.key});

  @override
  State<HomeView> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CityProvider cityProvider = Provider.of<CityProvider>(context);
    List<City> filteredCities =
        cityProvider.getFilteredCities(searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('dymatrip'),
      ),
      drawer: const DymaDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une ville',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => searchController.clear()),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              //Nous utilisons le Widget RefreshIndicator qui permet d'ajouter le comportement glisser pour rafraichir.
              // Cela permet à l'utilisateur de glisser du haut vers le bas pour lancer une requête de rafraîchissement.
              // Il permet également d'afficher un icône de chargement pour indiquer à l'utilisateur qu'une requête de mise à jour a été lancée.
              child: RefreshIndicator(
                displacement: 100.0,
                onRefresh:
                    Provider.of<CityProvider>(context, listen: false).fetchData,
                child: filteredCities.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (_, i) => CityCard(
                          city: filteredCities[i],
                        ),
                      )
                    : const Text('Aucun résultat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
