import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_imports/screens/maps/marker_screen.dart';

class DataService {
  List<Marker> returnList = List<Marker>();
  DocumentSnapshot document;
  GeoPoint geoPoint;
  LatLng latLng;
  int markerId;
  List<dynamic> markerIdList;

  Future<List<Marker>> getUserFavoriterRestaurant(String id) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(id)
        .doc('restaurant')
        .collection('marker')
        .get();

    var restaurants = await FirebaseFirestore.instance
        .collection('markers')
        .doc('restaurant')
        .collection('marker')
        .get();

    if (snapshot.docs[0].exists) {
      snapshot.docs
          .map(
            (e) => markerIdList = e.data()['id'],
          )
          .toList();

      return getUserFavoriteMarkers(markerIdList, restaurants);
    } else {
      return returnList;
    }
  }

  Future<List<Marker>> getUserFavoriterHotel(String id) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(id)
        .doc('hotel')
        .collection('marker')
        .get();

    var hotels = await FirebaseFirestore.instance
        .collection('markers')
        .doc('hotel')
        .collection('marker')
        .get();

    snapshot.docs
        .map(
          (e) => markerIdList = e.data()['id'],
        )
        .toList();

    if (snapshot.docs[0].exists) {
      return getUserFavoriteMarkers(markerIdList, hotels);
    } else {
      return returnList;
    }
  }

  Future<List<Marker>> getUserFavoriterBar(String id) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(id)
        .doc('bar')
        .collection('marker')
        .get();

    var bars = await FirebaseFirestore.instance
        .collection('markers')
        .doc('bar')
        .collection('marker')
        .get();

    snapshot.docs
        .map(
          (e) => markerIdList = e.data()['id'],
        )
        .toList();

    if (snapshot.docs[0].exists) {
      return getUserFavoriteMarkers(markerIdList, bars);
    } else {
      return returnList;
    }
  }

  Future<List<Marker>> getUserFavoriteMarkers(
      List<dynamic> favMarkers, QuerySnapshot allMarkers) async {
    returnList = List<Marker>();
    for (var ids in favMarkers) {
      markerId = allMarkers.docs.indexWhere((element) => element.id == ids);
      if (markerId != -1) {
        document = allMarkers.docs[markerId];
        geoPoint = document.data()['position'];
        latLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
        returnList.add(
          Marker(
              markerId: MarkerId(document.id),
              infoWindow: InfoWindow(title: document.data()['name']),
              position: latLng),
        );
      }
    }
    return returnList;
  }

  Future<void> addFavoriteMarker(
      String id, String category, String markerId) async {
    await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(id)
        .doc(category)
        .collection('marker')
        .doc('favorite')
        .update({
      'id': FieldValue.arrayUnion([markerId]),
    });
  }

  Future<void> removeFavoriteMarker(
      String id, String category, String markerId) async {
    await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(id)
        .doc(category)
        .collection('marker')
        .doc('favorite')
        .update({
      'id': FieldValue.arrayRemove([markerId]),
    });
  }

  Future<List<Marker>> getMarkers(
      String category, context, String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('markers')
        .doc(category)
        .collection('marker')
        .get();

    for (var x in snapshot.docs) {
      geoPoint = x.data()['position'];
      latLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      returnList.add(
        Marker(
          markerId: MarkerId(x.id),
          position: latLng,
          infoWindow: InfoWindow(
            title: x.data()['name'],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarkerTab(
                  name: x.data()['name'],
                  category: category,
                  markerId: x.id,
                  userId: userId,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return returnList;
  }

  Future<bool> checkFavoriteMarker(
      String markerId, String category, String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .doc('user')
        .collection(userId)
        .doc(category)
        .collection('marker')
        .get()
        .catchError((e) {});

    snapshot.docs
        .map(
          (e) => markerIdList = e.data()['id'],
        )
        .toList();

    for (var ids in markerIdList) {
      if (ids == markerId) {
        return true;
      }
    }
    return false;
  }
}
