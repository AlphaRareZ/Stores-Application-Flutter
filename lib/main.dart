import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_application/FavoriteProvider.dart';
import 'package:stores_application/StoresPage.dart';

void main(List<String> args) {
  runApp(ChangeNotifierProvider(
    create: (context) => FavoriteProvider(),
    child: MaterialApp(
      home: StoresPage(),
    ),
  ));
}
