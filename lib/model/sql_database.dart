// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:stores_application/main.dart';
import 'package:stores_application/model/store.dart';
import 'package:stores_application/model/user.dart';

class SQLDatabase {
  static Database? _db;
  Future<Database?> get db async {
    _db ??= await initialDB();
    return _db;
  }

  initialDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'stores_application2.db');
    print(path);
    Database database =
        await openDatabase(path, onCreate: _onCreate, version: 1);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Users (
      uid integer not null primary key autoincrement,
      name text,
      gender text,
      email text,
      password text
    );
    ''');
    await db.execute('''
    Create table Stores(
      sid integer not null primary key autoincrement,
      name text,
      lat real,
      lon real,
      photolink text
    );
    ''');
    await db.execute('''
    Create table Favorite_Stores(
      uid integer,
      sid integer
    );
    ''');
  }

  readData(String sql) async {
    Database? mydb = await db;
    Future<List<Map>> response = mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawDelete(sql);
    return response;
  }

  myDeleteDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'stores_application2.db');
    deleteDatabase(path);
    print("DELETED SUCCESSFULLY");
  }

  Future<bool> emailExists(String email) async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.rawQuery("select * from users where email = '$email'");
    return response.length == 1;
  }

  void addUser(User user) async {
    String? name = user.name;
    String? gender = user.gender;
    String? email = user.email;
    String? password = user.password;

    await insertData(
        "insert into users('name','gender','email','password') values ('$name','$gender','$email','$password')");
    print("User Added Sucessfully");
  }

  emailAndPassExists(String email, String password) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(
        "select * from users where email = '$email' and password = '$password'");
    return response;
  }

  Future<List<Store>> loadStores() async {
    List<Store> list = [];
    var response = await readData("select * from stores");
    for (var element in response) {
      list.add(Store(element['sid'], element['name'], element['photolink'],
          element['lat'], element['lon']));
    }
    // print(list[0].id);
    // print(list[0].name);
    // print(list[0].photoLink);
    // print(list[0].latitude);
    // print(list[0].longitude);
    return list;
  }

  Future<List<Store>> loadFavoriteStores(int? id) async {
    SQLDatabase database = SQLDatabase();
    List<Store> list = [];
    var response =
        await readData("select sid from favorite_stores where uid = $id");
    final stores = await database.loadStores();
    for (var element in response) {
      for (var store in stores) {
        if (store.id == element['sid']) {
          list.add(store);
        }
      }
    }
    return list;
  }

  deleteFavoriteStore(int id) async {
    int? currUID = currentUser.id;
    await deleteData(
        "delete from favorite_stores where uid = $currUID and sid = $id");
    print("removed from favorites successfully $currUID $id");
  }

  void addFavoriteStore(int id) async {
    int? currUID = currentUser.id;
    await insertData(
        "insert into favorite_stores ('uid','sid') values( $currUID, $id)");
  }

  void insertStores() async {
    List<Map> stores = await readData("select name from stores");
    if (stores.isEmpty) {
      print("Inserting Stores");
      await insertData('''
    insert into stores ('name','lat','lon','photolink') values
    ('Al Yemen Al Saeed',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('Abu Shaqra',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('Konafa We Basbosa',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('Qasr El Mandy',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('BIM',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('Chickana',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('Franco Cafe',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('Safari Restaurant',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172'),
    ('El Refa3y',30.013056,31.208853,'https://images.deliveryhero.io/image/talabat/Menuitems/3_1_2021-talabat-egy_637467532385486513.jpg?width=172&amp;height=172')
  ''');
    }
    else {
      print("There is Already Stores in DB");
    }

  }
}
