import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stores_application/model/store.dart';
import 'package:stores_application/screens/favorite_screen.dart';
import 'package:stores_application/FavoriteProvider.dart';
import 'package:stores_application/screens/sql_database.dart';
import 'package:stores_application/main.dart';
import 'package:stores_application/map_widget.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  List<Store> stores = [];
  List<Store> favStores = [];

  @override
  void initState() {
    super.initState();
    loadStores();
  }

  Future<void> loadStores() async {
    SQLDatabase database = SQLDatabase();
    stores = await database.loadStores();
    favStores = await database.loadFavoriteStores(currentUser.id);
    setState(() {}); // Trigger a rebuild of the widget
  }

  @override
  Widget build(BuildContext context) {
    SQLDatabase database = SQLDatabase();
    final provider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade300,
          toolbarHeight: 80,
          title: const Text(
            "Stores",
            style: TextStyle(fontSize: 50, fontFamily: 'Pacifico'),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  // var response =
                  //     await database.readData("select * from stores");
                  // print(response);
                  final route = MaterialPageRoute(
                      builder: (context) => const FavoritePage());
                  Navigator.push(context, route);
                },
                icon: const Icon(Icons.favorite)),
            IconButton(
                onPressed: () async {
                  provider.loadFavoriteStores(favStores);
                },
                icon: const Icon(Icons.refresh)),
          ],
        ),
        body: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final Store store = stores[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(store.photoLink),
                ),
                title: Text(
                  store.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: provider.exists(store)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        provider.toggleFavorite(store);
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          final route = MaterialPageRoute(
                              builder: (context) => DistanceMapWidget(
                                  destinationPosition:
                                      LatLng(store.latitude, store.longitude)));
                          Navigator.push(context, route);
                        },
                        icon: Icon(Icons.location_on_outlined)),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
