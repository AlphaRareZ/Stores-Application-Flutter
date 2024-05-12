import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores_application/favorite_provider.dart';
import 'package:stores_application/model/user.dart';
import 'package:stores_application/screens/login_screen.dart';

User currentUser = User(null, name: null, gender: null, email: null, password: null);

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(ChangeNotifierProvider(
    create: (context) => FavoriteProvider(),
    child: const MaterialApp(
      home: LoginScreen(),
    ),
  ));
}
