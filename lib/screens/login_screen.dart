import 'package:flutter/material.dart';
import 'package:stores_application/main.dart';
import 'package:stores_application/screens/stores_screen.dart';
import 'package:stores_application/model/sql_database.dart';
import 'signup_screen.dart';
import '../style/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isFciEmail(String value) {
    // omar@stud.fci-cu.edu.eg
    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$');
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final SQLDatabase database = SQLDatabase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontFamily: 'Pacifico'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 200.0),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!_isFciEmail(value)) {
                      return 'Please enter a valid FCI email';
                    }

                    return null;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildInputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: buildInputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                    )),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // print("Sign in Form Submitted");
                      List<Map> response = await database.emailAndPassExists(
                          emailController.text, passwordController.text);
                      // print(response);
                      if (response.isNotEmpty) {
                        currentUser.id = response[0]['uid'];
                        currentUser.name = response[0]['name'];
                        currentUser.gender = response[0]['gender'];
                        currentUser.email = response[0]['email'];
                        currentUser.password = response[0]['password'];
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const StoresPage();
                        }));

                        // print(currentUser.id);
                        // print(currentUser.name);
                        // print(currentUser.gender);
                        // print(currentUser.email);
                        // print(currentUser.password);
                      } else {
                        // print("Email Does Not Exist");
                      }
                    }
                  },
                  child: const Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const Text('Has no Account?',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 18)),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                        },
                        child: const Text('Register',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
