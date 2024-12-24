import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_build_apk/firebase_options.dart';
import 'package:test_build_apk/screens/login.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: buildElegantTheme(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white70, // Customize app bar background color
          foregroundColor: Colors.white, // Customize app bar text color
          titleTextStyle: TextStyle(
            fontSize: 20, // Customize app bar title text size
          ),
        ),
      ),

      //for homepage
      // home: HomePage(),

      //for login
      home: SignInPage1(),

      //for create acc
      // home: NewAcc(),

      //for map
      //home: OpenStreetMapScreen(),

      //googlemaps
      // home: SampleGoogleMaps(),

      //for user profile
      //home: UserProfile(),

      //this is for testing the eonet
      // home: MyHomePage(),

      //this is for testing overlay
      // home: const OverLayWidgetSample(),

      //for testing geolocator
      //home: CurrentLoc(),

      //for monitor screen
//home: MonitorLocation(),
    );
  }

  ThemeData buildElegantTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
        headline6: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.white70,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.black12,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blueAccent,
      ),
    );
  }
}
