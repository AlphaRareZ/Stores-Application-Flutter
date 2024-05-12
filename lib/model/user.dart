class User {
  int? id;
  String? name, gender, email, password;

  User(
    this.id, {
    required this.name,
    required this.gender,
    required this.email,
    required this.password,
  });
}
