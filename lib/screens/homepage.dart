import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:test_build_apk/screens/homepageScreen/currentloc.dart';
import 'package:test_build_apk/screens/homepageScreen/homescreenbody1.dart';
import 'package:test_build_apk/screens/homepageScreen/user.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.userId, required this.datafields});

  var userId;
  var datafields;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> events = [];

  Future<void> fetchEventData() async {
    final Uri url = Uri.parse(
        'https://eonet.gsfc.nasa.gov/api/v3/events?source=InciWeb,EO,AVO,ABFIRE,AU_BOM,BYU_ICE,Earthdata,FEMA,FloodList,GDACS,GLIDE,IDC,JTWC,MRR,MBFIRE,NASA_ESRS,NASA_DISP,NASA_HURR,NOAA_NHC,NOAA_CPC,PDC,ReliefWeb,SIVolcano,NATICE,UNISYS,USGS_EHP,USGS_CMT,HDDS,DFES_WA&status=open&days=20');
    final response = await http.get(url);

    // final Uri url = Uri.https(
    //     'https://eonet.gsfc.nasa.gov/api/v3/categories/wildfires?limit=5');
    // final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        events = List<Map<String, dynamic>>.from(data['events']);
      });
    } else {
      throw Exception('Failed to load event data');
    }
  }

  void getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show a dialog to open location settings
      bool openLocationSettings = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Services Disabled"),
            content: Text("Please enable location services to use this app."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, false); // Return false to indicate cancel
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, true); // Return true to indicate open settings
                },
                child: Text("Open Settings"),
              ),
            ],
          );
        },
      );

      if (openLocationSettings == true) {
        await Geolocator.openLocationSettings();
      }
    } else {
      // Location services are enabled, get the current position
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEventData();
  }

  bool category1 = false;
  bool category2 = false;
  bool category3 = false;
  // String limit = '';
  var limit = TextEditingController();
  bool status = true;

  @override
  Widget build(BuildContext context) {
    //Widget body;

    Widget body;

    switch (_selectedIndex) {
      case 0:
        body = HomeScreenBody1(
          datafields: widget.datafields,
          userId: widget.userId,
        ); // Home
        break;
      case 1:
        //body = HistoryScreen(); // History
        body = EventOnCurrentLoc(
            datafields: widget.datafields, userId: widget.userId);
        break;
      // case 2:
      //   body = MonitorLocation(
      //       datafields: widget.datafields, userId: widget.userId);
      //   break;
      case 2:
        body = UserProfile(
            datafields: widget.datafields, userId: widget.userId); // User
        break;
      default:
        body = Container(); // Handle other cases if needed
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('GeoEvent'),
        leading: Image.asset(
          'assets/images/logo1.png',
          width: 40,
          height: 40,
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return showModalBottomSheetContent();
                  },
                );
              },
              icon: Icon(Icons.notifications),
              label: Text("Notification"))
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Events on your Location',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.monitor_outlined),
          //   label: 'Monitor Location',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (value) {
          if (value < 4) {
            setState(() {
              _selectedIndex = value;
            });
            print(_selectedIndex);
          }
        },
      ),
    );
  }

  Widget showModalBottomSheetContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On going event for the past 20 days:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 1, // Change thickness as per your requirement
              color: Colors.black, // Change color as per your requirement
            ),
            SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = events[index];
                  final categoryTitle = event['categories'][0]['title'];
                  final coordinates = event['geometry'][0]['coordinates'];
                  final latitude = coordinates[1];
                  final longitude = coordinates[0];

                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(event['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(categoryTitle),
                          Text('Coordinates: $latitude, $longitude'),
                          if (event['description'] != null)
                            Text(event['description'])
                          else
                            Text('No description available'),
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
