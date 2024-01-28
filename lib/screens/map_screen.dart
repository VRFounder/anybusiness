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
  Set<Marker> _markers = {};
  LatLng? _pickedLocation;
  Map<String, dynamic>? _dataFromAPI;
  String? _selectedSphere; // Variable to hold the selected sphere
  List<String> spheres = ['Restaurant', 'Retail', 'Technology']; // Example spheres, replace with your own

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
      // Clear existing markers and add new one
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ),
      );
    });
  }

  void _analyzeLocation() async {
    if (_pickedLocation == null || _selectedSphere == null) {
      _showErrorDialog('Please select a location and a sphere.');
      return;
    }

    var url = Uri.parse('https://enigmatic-earth-88985-54b0ffead0e6.herokuapp.com/get_data');
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'latitude': _pickedLocation!.latitude,
          'longitude': _pickedLocation!.longitude,
          'sphere': _selectedSphere,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _dataFromAPI = data;
        });
        _showModalBottomSheet();
      } else {
        _showErrorDialog('Error: Server responded with status code ${response.statusCode}.');
      }
    } catch (e) {
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
              String successRate = _dataFromAPI![key] as String; // Assuming the value is a double

              // Use the custom widget to display the sphere and success rate
              return BusinessSphereCard(sphere: key, successRate: successRate);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
        actions: [
          DropdownButton<String>(
            value: _selectedSphere,
            hint: const Text('Select Sphere', style: TextStyle(color: Colors.white)),
            onChanged: (newValue) {
              setState(() {
                _selectedSphere = newValue;
              });
            },
            items: spheres.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _analyzeLocation,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 13,
        ),
        minMaxZoomPreference: const MinMaxZoomPreference(1, 100),
        markers: _markers,
        onTap: _selectLocation,
      ),
    );
  }
}


class BusinessSphereCard extends StatelessWidget {
  final String sphere;
  final String successRate;

  const BusinessSphereCard({
    Key? key,
    required this.sphere,
    required this.successRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Adjust elevation for a shadow effect
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sphere,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Success Rate: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$successRate%',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
