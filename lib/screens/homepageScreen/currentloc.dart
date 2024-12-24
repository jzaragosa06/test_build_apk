import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EventOnCurrentLoc extends StatefulWidget {
  EventOnCurrentLoc(
      {super.key, required this.userId, required this.datafields});

  var userId;
  var datafields;

  @override
  State<EventOnCurrentLoc> createState() => _EventOnCurrentLocState();
}

class _EventOnCurrentLocState extends State<EventOnCurrentLoc> {
  late Future<void> weatherFuture;
  double? temperature;
  String? description;
  double? windSpeed;
  int? humidity;

  Position? position;

  var distController = TextEditingController();

  List<Map<String, dynamic>> events = [];

  int closeCount = 0;

  Future<void> fetchEventData() async {
    final Uri url = Uri.parse(
        'https://eonet.gsfc.nasa.gov/api/v3/events?source=InciWeb,EO,AVO,ABFIRE,AU_BOM,BYU_ICE,Earthdata,FEMA,FloodList,GDACS,GLIDE,IDC,JTWC,MRR,MBFIRE,NASA_ESRS,NASA_DISP,NASA_HURR,NOAA_NHC,NOAA_CPC,PDC,ReliefWeb,SIVolcano,NATICE,UNISYS,USGS_EHP,USGS_CMT,HDDS,DFES_WA&status=open');
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

  Future<void> getWeather() async {
    position = await Geolocator.getCurrentPosition();
    final url = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {
        'lat': position!.latitude.toString(),
        'lon': position!.longitude.toString(),
        'appid': '797e5f4926d5f4094db2704a470df03f',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        temperature = (json['main']['temp'] - 273.15);
        description = json['weather'][0]['description'];
        windSpeed = json['wind']['speed'];
        humidity = json['main']['humidity'];
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    weatherFuture = getWeather();
    fetchEventData();

    distController.text = "2000";
  }

  @override
  Widget build(BuildContext context) {
    closeCount = 0;
    return Scaffold(
      body: FutureBuilder(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        LatLng(position!.latitude, position!.longitude),
                    initialZoom: 13,
                    interactionOptions: const InteractionOptions(
                      flags: ~InteractiveFlag.doubleTapDragZoom,
                    ),
                  ),
                  children: [
                    openStreetMapTileLayer,
                    MarkerLayer(
                      markers: [
                            if (position != null)
                              Marker(
                                point: LatLng(
                                    position!.latitude, position!.longitude),
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
                          events
                              .map((event) {
                                final coordinates =
                                    event['geometry'][0]['coordinates'];
                                final lat = coordinates[1];
                                final lng = coordinates[0];

                                final title = event['title'];
                                final categoryTitle =
                                    event['categories'][0]['title'];
                                final sourceLoc = event['sources'][0]['id'];
                                final sourceUrl = event['sources'][0]['url'];

                                //this calcuates the distance in meters
                                var distBetween = Geolocator.distanceBetween(
                                  position!.latitude,
                                  position!.longitude,
                                  lat,
                                  lng,
                                );

                                distBetween = distBetween / 1000;

                                print(distBetween);

                                if (double.parse(distController.text) >=
                                    distBetween) {
                                  ++closeCount;
                                  return Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: LatLng(lat, lng),
                                    child: GestureDetector(
                                      onTap: () {
                                        QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.warning,
                                            onConfirmBtnTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            title:
                                                'Information about the event:',
                                            // text:
                                            //     'Title: $title\nCategory: $categoryTitle\nSource: $sourceLoc\nSource URL: $sourceUrl\nStatus: Open',
                                            widget: buildEventInfo(
                                                title,
                                                categoryTitle,
                                                sourceLoc,
                                                sourceUrl,
                                                distBetween.toString()));
                                      },
                                      child: Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                } else {
                                  return null; // Return null for markers outside the distance
                                }
                              })
                              .where((marker) => marker != null)
                              .cast<Marker>()
                              .toList(), // Filter out null markers
                    ),
                  ],
                ),
                Positioned(
                  top: 20, // Position the widget 20 pixels from the top
                  left: 20,
                  right: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2, // TextField occupies 2/3 of the Row
                          child: TextField(
                            controller: distController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText:
                                    "Distance to natural event (in km): "),
                          ),
                        ),
                        SizedBox(
                            width:
                                10), // Add some space between TextField and Button
                        Flexible(
                          flex: 1, // Button occupies 1/3 of the Row
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                //closeCount = 0;
                              });
                              fetchEventData();
                              print('ElevatedButton pressed!');
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.info,
                                title: 'Current Location',
                                text:
                                    'There is/are ${closeCount} event(s) close to ${distController.text} Km to your location',
                                onConfirmBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            child: Text('Search'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return showModalBottomSheetContent();
            },
          );
        },
        tooltip: 'Current Weather',
        child: const Icon(Icons.sunny_snowing),
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
            Text("Weather on your location: "),
            Divider(
              thickness: 1, // Change thickness as per your requirement
              color: Colors.black, // Change color as per your requirement
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('${temperature}'),
                subtitle: Text("Temperature"),
                trailing: Icon(Icons.sunny),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('${description}'),
                subtitle: Text("Cloud Condition"),
                trailing: Icon(Icons.cloud_circle),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('${windSpeed}'),
                subtitle: Text("Windspeed"),
                trailing: Icon(Icons.air),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text('${humidity}'),
                subtitle: Text("Humidity"),
                trailing: Icon(Icons.water_drop),
              ),
            )
          ],
        ),
      ),
    );
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
