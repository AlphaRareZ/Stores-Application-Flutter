import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:stores_application/model/user.dart';
import 'package:stores_application/screens/sql_database.dart';

import '../style/style.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _gender;
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SQLDatabase database = SQLDatabase();
    bool _validateEmail(String value) {
      final RegExp emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$');

      if (!emailRegex.hasMatch(value)) {
        return false;
      }
      return true;
    }

    bool _isMatchPasswors(String value) {
      return true;
    }

    bool _isFciEmail(String value) {
      // omar@stud.fci-cu.edu.eg
      RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$');
      return regex.hasMatch(value);
    }

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Sign UP",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please enter your name!";
                    }
                  },
                  decoration: buildInputDecoration(
                    labelText: 'Name*',
                    prefixIcon: Icons.person,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Gender',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Radio(
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        activeColor: Colors.blue),
                    const Text('Male',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                    Radio(
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        activeColor: Colors.blue),
                    const Text('Female',
                        style: TextStyle(
                          color: Colors.blueGrey,
                        )),
                  ],
                ),
                const SizedBox(height: 20.0),
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
                    labelText: 'Email*',
                    prefixIcon: Icons.email,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return "Password at least 8 chars!";
                      }
                      return null;
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: buildInputDecoration(
                      labelText: 'Password*',
                      prefixIcon: Icons.lock,
                    )),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: buildInputDecoration(
                    labelText: 'Confirm Password*',
                    prefixIcon: Icons.lock,
                  ),
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "Please Enter Confirmed Password!";
                    }
                    if (e.length < 8) {
                      return "Password at least 8 chars!";
                    }
                    if (e != passwordController.text) {
                      return "Not Match the password!";
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print("Sign Up Form Submitted");

                      bool exists =
                          await database.emailExists(emailController.text);

                      if (exists) {
                        // Don't Add Them into Database but Display Message First

                        // ADD LOGIC HERE TO NOTIFY USER THAT THE EMAIL ALREADY EXISTS

                        print("Email Already Exists !");
                        return;
                      }

                      User newUser = User(0,
                          name: usernameController.text,
                          gender: _gender!,
                          email: emailController.text,
                          password: passwordController.text);

                      database.addUser(newUser);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
