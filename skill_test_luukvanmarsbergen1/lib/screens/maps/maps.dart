import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_imports/screens/maps/filter_screen.dart';

class Gmaps extends StatefulWidget {
  Gmaps({this.userId});

  final String userId;

  @override
  _GmapsState createState() => _GmapsState();
}

class _GmapsState extends State<Gmaps> {
  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.04648574109063, 4.514673043564661),
    zoom: 17,
  );
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markerList = List<Marker>();
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            markers: Set<Marker>.of(_markerList),
            mapType: MapType.satellite,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.grey[200].withOpacity(0.8),
            width: 40,
            height: 40,
            child: IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () => filterScreen(),
            ),
          ),
        ],
      ),
    );
  }

  filterScreen() {
    showDialog(
        context: context,
        builder: (_) {
          return MyDialog(userId: widget.userId, context: _context);
        }).then((value) {
      if (value != null) {
        setState(() {
          _markerList = value;
        });
      }
    });
  }
}
