import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  const MapScreen({super.key, this.location = const PlaceLocation(latitude: 41.311081, longitude: 69.240562, address: '')});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  Map<String, dynamic>? _dataFromAPI;

  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
    });

    var url = Uri.parse('https://enigmatic-earth-88985-54b0ffead0e6.herokuapp.com/get_data');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _dataFromAPI = data;
        });
        _showModalBottomSheet();
      } else {
        // Handle non-200 responses
        _showErrorDialog('Error: Server responded with status code ${response.statusCode}.');
      }
    } catch (e) {
      // Handle errors related to the HTTP request
      _showErrorDialog('Error: Unable to reach the server. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet() {
    if (_dataFromAPI == null) return;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: _dataFromAPI!.length,
            itemBuilder: (ctx, index) {
              String key = _dataFromAPI!.keys.elementAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    Text("$key: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(_dataFromAPI![key].toString()),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.311081, 69.240562),
          zoom: 13,
        ),
        minMaxZoomPreference: const MinMaxZoomPreference(1, 100),
        onTap: _selectLocation,
      ),
    );
  }
}