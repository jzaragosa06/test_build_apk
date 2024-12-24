import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'dart:convert';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MonitorLocation extends StatefulWidget {
  MonitorLocation({super.key, required this.userId, required this.datafields});

  var userId;
  var datafields;

  @override
  State<MonitorLocation> createState() => _MonitorLocationState();
}

class _MonitorLocationState extends State<MonitorLocation> {
  List<Marker> markers = [
    Marker(
        point: LatLng(2.2878, 103.86666),
        child: Icon(
          Icons.location_pin,
          size: 20,
          color: Colors.red,
        ))
  ];

  List<Map<String, dynamic>> events = [];
  List<LatLng> eventCoordinates = [];

  Future<void> fetchEventData() async {
    final Uri url = Uri.parse(
        'https://eonet.gsfc.nasa.gov/api/v3/events?&source=InciWeb,EO&status=open');
    final response = await http.get(url);

    // final Uri url = Uri.https(
    //     'https://eonet.gsfc.nasa.gov/api/v3/categories/wildfires?limit=5');
    // final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
    super.initState();
    fetchEventData();

    List<dynamic> latLngMapList = widget.datafields['latLngMapList'];
    List<LatLng> latLngList = latLngMapList.map((map) {
      double latitude = double.parse(map['latitude']);
      double longitude = double.parse(map['longitude']);
      return LatLng(latitude, longitude);
    }).toList();

    print(latLngList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(1.2878, 103.8666),
            initialZoom: 11,
            interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapDragZoom),
          ),
          children: [openStreetMapTileLayer, MarkerLayer(markers: markers)]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return Text("cat");
          //   },
          // );

          //WHEN YOU PRESS THIS, A LIST VIEW OF LOCATION TO BE MONITORED WILL BE DISPLAYED.
        },
        tooltip: 'Current Weather',
        child: const Icon(Icons.sunny_snowing),
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https:/tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
