import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_build_apk/screens/homepage.dart';
import 'package:test_build_apk/screens/login.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:geolocator/geolocator.dart';

class NewAcc extends StatefulWidget {
  const NewAcc({Key? key}) : super(key: key);

  @override
  State<NewAcc> createState() => _NewAccState();
}

class _NewAccState extends State<NewAcc> {
  bool _isPasswordVisible = false;

  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var numberController = TextEditingController();
  var addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadPosition();
  }

  // void loadPosition() async {
  //   position = await Geolocator.getCurrentPosition();
  // }

  //Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 350),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 200,
                    width: 200,
                  ),
                  _gap(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Create a New Account",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter your address',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      // Add contact number validation if needed

                      return null;
                    },
                    controller: numberController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      hintText: 'Enter your contact number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _gap(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    obscureText: !_isPasswordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        )),
                  ),
                  _gap(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          createAccountFunction();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => HomePage(),
                          //   ),
                          // );
                        }
                      },
                    ),
                  ),
                  _gap(),
                  Center(
                    child: TextButton(
                      child: Text("Already have an account? Sign in"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage1(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  void createAccountFunction() async {
    //perform an insert operation in database.  if it is success, change the boolean variable accordingly.
    //since we have no database, we're just assume that this is true
    bool isSuccess = true;

    if (isSuccess == true) {
      //we will store the info about the user in the class that perpetuates its value in multiple screen
      // final userData = UserData();

      String username = usernameController.text;
      String password = passwordController.text;
      String email = emailController.text;
      String address = addressController.text;
      // int number = int.parse(numberController.text);

      String number = numberController.text;

      //get the current location

      List<LatLng> latLngList = [
        // LatLng(position!.latitude, position!.longitude),
        LatLng(0, 0),
      ];

      List<Map<String, String>> latLngMapList = latLngList.map((latLng) {
        return {
          'latitude': latLng.latitude.toString(),
          'longitude': latLng.longitude.toString(),
        };
      }).toList();

      try {
        UserCredential userCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String userId = userCred.user!.uid;

        FirebaseFirestore.instance.collection('client_users').doc(userId).set({
          'name': username,
          'email': email,
          'number': number,
          'address': address,
          'latLngMapList': latLngMapList,
        });

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'success',
          text: 'please login',
        );
        // Navigator.of(context).pop();

        Navigator.of(context).pop();
      } on FirebaseAuthException catch (ex) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'ERROR',
          text: 'You have an error. fix it: ',
        );
        Navigator.of(context).pop();
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  'Account Created',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your new account has been created successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Dismiss the success dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage1(),
                      ),
                    );
                  },
                  child: Text('Okay'),
                ),
              ],
            ),
          );
        },
      );

      //this is for displaying that create acccount successful
    }
  }
}
