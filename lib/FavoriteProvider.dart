import 'package:flutter/material.dart';
import 'package:stores_application/store.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Store> stores = [];
  void toggleFavorite(Store store) {
    bool exist = false;
    Store? tempStore;
    for (var x in stores) {
      if (x.name == store.name &&
          x.location == store.location &&
          store.photoLink == x.photoLink) {
        exist = true;
        tempStore = x;
        break;
      }
    }
    if (exist) {
      stores.remove(tempStore);
    } else {
      stores.add(store);
    }
    notifyListeners();
  }

  bool exists(Store store) {
    bool exists = false;
    for (var x in stores) {
      if (x.name == store.name &&
          x.location == store.location &&
          store.photoLink == x.photoLink) {
        exists = true;
        break;
      }
    }
    return exists;
  }
}
