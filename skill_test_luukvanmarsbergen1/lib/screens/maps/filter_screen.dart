import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_imports/services/data.dart';

class MyDialog extends StatefulWidget {
  MyDialog({this.userId, this.context});

  final String userId;
  final context;

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List<Marker> _markerList = List<Marker>();
  List<Marker> restaurantMarkers = List<Marker>();
  List<Marker> barsMarkers = List<Marker>();
  List<Marker> hotelMarkers = List<Marker>();

  DataService _data = DataService();
  bool hotelsAdded = false;
  bool restaurantsAdded = false;
  bool barsAdded = false;

  getMarkers() async {
    _markerList = [...restaurantMarkers, ...hotelMarkers, ...barsMarkers];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter op categorie'),
      content: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  onChanged: changeRestaurantsFilter,
                  value: restaurantsAdded,
                ),
                Text(
                  'Restaurants',
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  onChanged: changeBarsFilter,
                  value: barsAdded,
                ),
                Text(
                  'Bars',
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  onChanged: changeHotelFilter,
                  value: hotelsAdded,
                ),
                Text(
                  'Hotels',
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Spacer(),
                FlatButton(
                  child: Text(
                    "Filter",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.pop(context, _markerList),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  changeBarsFilter(bool newValue) async {
    if (!barsAdded) {
      barsMarkers = await _data.getMarkers('bar', widget.context, widget.userId);
    } else {
      barsMarkers.clear();
    }
    barsAdded = newValue;

    getMarkers();
  }

  void changeHotelFilter(bool newValue) async {
    if (!hotelsAdded) {
      hotelMarkers = await _data.getMarkers('hotel', widget.context, widget.userId);
    } else {
      hotelMarkers.clear();
    }
    hotelsAdded = newValue;

    getMarkers();
  }

  changeRestaurantsFilter(bool newValue) async {
    if (!restaurantsAdded) {
      restaurantMarkers =
          await _data.getMarkers('restaurant', widget.context, widget.userId);
    } else {
      restaurantMarkers.clear();
    }
    restaurantsAdded = newValue;

    getMarkers();
  }
}
