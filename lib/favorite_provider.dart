import 'package:flutter/material.dart';
import 'package:stores_application/model/store.dart';
import 'package:stores_application/model/sql_database.dart';

class FavoriteProvider extends ChangeNotifier {
  // get all favorite stores for current user then add them into stores then notify listeners

  List<Store> stores = [];

  void toggleFavorite(Store store) {
    SQLDatabase database = SQLDatabase();
    bool exist = false;
    Store? tempStore;
    for (var x in stores) {
      if (x.id == store.id) {
        exist = true;
        tempStore = x;
        break;
      }
    }
    if (exist) {
      stores.remove(tempStore);
      database.deleteFavoriteStore(tempStore!.id);
    } else {
      database.addFavoriteStore(store.id);
      stores.add(store);
    }
    notifyListeners();
  }

  bool exists(Store store) {
    bool exists = false;
    for (var x in stores) {
      if (x.name == store.name &&
          x.latitude == store.latitude &&
          x.longitude == store.longitude &&
          x.photoLink == store.photoLink) {
        exists = true;
        break;
      }
    }
    return exists;
  }

  void loadFavoriteStores(List<Store> list) {
    stores = list;
    notifyListeners();
  }
}
