// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;

// class HomeScreenBody1 extends StatefulWidget {
//   HomeScreenBody1({super.key, required this.userId, required this.datafields});

//   var userId;
//   var datafields;

//   @override
//   State<HomeScreenBody1> createState() => _HomeScreenBody1State();
// }

// class _HomeScreenBody1State extends State<HomeScreenBody1> {
//   List<Map<String, dynamic>> events = [];
//   List<LatLng> eventCoordinates = [];

//   Future<void> fetchEventData() async {
//     final Uri url = Uri.parse(
//         'https://eonet.gsfc.nasa.gov/api/v3/events?&source=InciWeb,EO&status=open');
//     final response = await http.get(url);

//     // final Uri url = Uri.https(
//     //     'https://eonet.gsfc.nasa.gov/api/v3/categories/wildfires?limit=5');
//     // final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         events = List<Map<String, dynamic>>.from(data['events']);

//         eventCoordinates = events
//             .map((event) => LatLng(
//                   event['geometry'][0]['coordinates'][1],
//                   event['geometry'][0]['coordinates'][0],
//                 ))
//             .toList();
//       });
//       print(eventCoordinates);
//     } else {
//       throw Exception('Failed to load event data');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchEventData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FlutterMap(
//             options: MapOptions(
//               initialCenter: LatLng(1.2878, 103.8666),
//               initialZoom: 11,
//               interactionOptions: const InteractionOptions(
//                   flags: ~InteractiveFlag.doubleTapDragZoom),
//             ),
//             children: [
//           openStreetMapTileLayer,
//           MarkerLayer(
//             markers: eventCoordinates.map((coordinate) {
//               return Marker(
//                   width: 40.0,
//                   height: 40.0,
//                   point: coordinate,
//                   child: GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: Text("cat"),
//                         ),
//                       );
//                     },
//                     child: Icon(
//                       Icons.location_pin,
//                       color: Colors.red,
//                     ),
//                   ));
//             }).toList(),
//           )
//         ]));
//   }
// }

// TileLayer get openStreetMapTileLayer => TileLayer(
//       urlTemplate: 'https:/tile.openstreetmap.org/{z}/{x}/{y}.png',
//       userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//     );

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class HomeScreenBody1 extends StatefulWidget {
  HomeScreenBody1({super.key, required this.userId, required this.datafields});

  var userId;
  var datafields;

  @override
  State<HomeScreenBody1> createState() => _HomeScreenBody1State();
}

class _HomeScreenBody1State extends State<HomeScreenBody1> {
  List<Map<String, dynamic>> events = [];
  List<LatLng> eventCoordinates = [];

  Position? position;

  Future<void> fetchEventData() async {
    final Uri url = Uri.parse(
        'https://eonet.gsfc.nasa.gov/api/v3/events?source=InciWeb,EO,AVO,ABFIRE,AU_BOM,BYU_ICE,Earthdata,FEMA,FloodList,GDACS,GLIDE,IDC,JTWC,MRR,MBFIRE,NASA_ESRS,NASA_DISP,NASA_HURR,NOAA_NHC,NOAA_CPC,PDC,ReliefWeb,SIVolcano,NATICE,UNISYS,USGS_EHP,USGS_CMT,HDDS,DFES_WA&status=open');
    final response = await http.get(url);

    // final Uri url = Uri.https(
    //     'https://eonet.gsfc.nasa.gov/api/v3/categories/wildfires?limit=5');
    // final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      position = await Geolocator.getCurrentPosition();
      setState(() {
        events = List<Map<String, dynamic>>.from(data['events']);

        eventCoordinates = events
            .map((event) => LatLng(
                  event['geometry'][0]['coordinates'][1],
                  event['geometry'][0]['coordinates'][0],
                ))
            .toList();
      });
      print(eventCoordinates);
    } else {
      throw Exception('Failed to load event data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(15.939601, 120.455098),
              initialZoom: 8,
              interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapDragZoom),
            ),
            children: [
          openStreetMapTileLayer,
          MarkerLayer(
            markers: [
                  if (position != null)
                    Marker(
                      point: LatLng(position!.latitude, position!.longitude),
                      child: GestureDetector(
                        onTap: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            title: 'Current Location',
                            text:
                                'Latitude: ${position!.latitude} \n Longitude: ${position!.longitude}',
                          );
                        },
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ] +
                events.map((event) {
                  final coordinates = event['geometry'][0]['coordinates'];
                  final lat = coordinates[1];
                  final lng = coordinates[0];

                  final title = event['title'];
                  final categoryTitle = event['categories'][0]['title'];
                  final sourceLoc = event['sources'][0]['id'];
                  final sourceUrl = event['sources'][0]['url'];

                  var distBetween = Geolocator.distanceBetween(
                    position!.latitude,
                    position!.longitude,
                    lat,
                    lng,
                  );

                  distBetween = distBetween / 1000;

                  return Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(lat, lng),
                    child: GestureDetector(
                      onTap: () {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                            },
                            title: 'Information about the event:',
                            // text: Column(
                            //   children: [
                            //     Text('Event Title: ${title} '),
                            //     Divider(
                            //       thickness:
                            //           1, // Change thickness as per your requirement
                            //       color: Colors
                            //           .black, // Change color as per your requirement
                            //     ),
                            //     Text('Category: ${categoryTitle}'),
                            //     Text('Source: ${sourceLoc}'),
                            //     Text('Source Url: ${sourceUrl}'),
                            //   ],
                            // ).toString()
                            // text:
                            //     'Title: ${title}\n Category: ${categoryTitle} \n Source: ${sourceLoc} \n Source URL: ${sourceUrl} \n Status: Open');
                            widget: buildEventInfo(title, categoryTitle,
                                sourceLoc, sourceUrl, distBetween.toString()));
                      },
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                      ),
                    ),
                  );
                }).toList(),
          )
        ]));
  }

  Widget buildEventInfo(String title, String categoryTitle, String sourceLoc,
      String sourceUrl, String dist) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: 'Title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '$title\n'),
          TextSpan(
            text: 'Category: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '$categoryTitle\n'),
          TextSpan(
            text: 'Source: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '$sourceLoc\n'),
          TextSpan(
            text: 'Source URL: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '$sourceUrl\n'),
          TextSpan(
            text: 'Distance to You: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '$dist Km\n'),
          TextSpan(
            text: 'Status: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: 'Open'),
        ],
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https:/tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
