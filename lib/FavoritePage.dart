import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_application/FavoriteProvider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final stores = provider.stores;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade300,
          toolbarHeight: 80,
          title: Text(
            "Favorites",
            style: TextStyle(fontSize: 50, fontFamily: 'Pacifico'),
          ),
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
