import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_application/FavoritePage.dart';
import 'package:stores_application/FavoriteProvider.dart';
import 'package:stores_application/store.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final stores = items();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade300,
          toolbarHeight: 80,
          title: Text(
            "Stores",
            style: TextStyle(fontSize: 50, fontFamily: 'Pacifico'),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  final route =
                      MaterialPageRoute(builder: (context) => FavoritePage());
                  Navigator.push(context, route);
                },
                icon: Icon(Icons.favorite))
          ],
        ),
        body: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(store.photoLink),
                ),
                title: Text(
                  store.name,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
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
              ),
            );
          },
        ));
  }
}

List<Store> items() {
  return [
    Store("Yemen Al Saeed", "location",
        "https://lh3.googleusercontent.com/p/AF1QipO8OHZZWJE41HDWD8ktWnaYu7D71mgFJRNH8pwH=w768-h768-n-o-v1"),
    Store("Publix", "location",
        "https://lh3.googleusercontent.com/p/AF1QipO8OHZZWJE41HDWD8ktWnaYu7D71mgFJRNH8pwH=w768-h768-n-o-v1"),
    Store("Abu Shaqra", "location",
        "https://lh3.googleusercontent.com/p/AF1QipO8OHZZWJE41HDWD8ktWnaYu7D71mgFJRNH8pwH=w768-h768-n-o-v1"),
    Store("Layalina Cafe", "location",
        "https://lh3.googleusercontent.com/p/AF1QipO8OHZZWJE41HDWD8ktWnaYu7D71mgFJRNH8pwH=w768-h768-n-o-v1"),
    Store("Chickana", "location",
        "https://lh3.googleusercontent.com/p/AF1QipO8OHZZWJE41HDWD8ktWnaYu7D71mgFJRNH8pwH=w768-h768-n-o-v1"),
    Store("Karam El Sham", "location",
        "https://lh3.googleusercontent.com/p/AF1QipO8OHZZWJE41HDWD8ktWnaYu7D71mgFJRNH8pwH=w768-h768-n-o-v1"),
  ];
}
