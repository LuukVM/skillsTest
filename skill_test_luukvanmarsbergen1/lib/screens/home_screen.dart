import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_imports/inherited_widget.dart';
import 'package:test_imports/screens/login/sign_in_screen.dart';
import 'package:test_imports/screens/maps/maps.dart';
import 'package:test_imports/screens/maps/marker_screen.dart';
import 'package:test_imports/services/auth.dart';
import 'package:test_imports/services/data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  DataService _data = DataService();
  BuildContext _context;

  List<Marker> hotelList;
  List<Marker> barList;
  List<Marker> restaurantList;

  @override
  void initState() {
    hotelList = List<Marker>();
    barList = List<Marker>();
    restaurantList = List<Marker>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataGetter.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welkom!"),
        actions: [
          IconButton(
            onPressed: () => logOut(context),
            icon: Icon(
              Icons.exit_to_app,
              size: 26.0,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Gmaps(
                      userId: _userData.user.id.toString(),
                    ))).then((value) {
          setState(() {});
        }),
        child: Icon(Icons.map),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Marker>>(
              future: _data.getUserFavoriterRestaurant(_userData.user.id),
              builder: (context, snapshot) {
                restaurantList = snapshot.data;
                return ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(restaurantList == null
                      ? "Loading"
                      : "Restaurants: " + restaurantList.length.toString()),
                  children: [
                    Column(
                      children: buildItem(
                          restaurantList, "restaurant", _userData.user.id),
                    )
                  ],
                );
              },
            ),
            FutureBuilder<List<Marker>>(
              future: _data.getUserFavoriterHotel(_userData.user.id),
              builder: (context, snapshot) {
                hotelList = snapshot.data;
                return ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(hotelList == null
                      ? "Loading"
                      : "Hotels: " + hotelList.length.toString()),
                  children: [
                    Column(
                      children:
                          buildItem(hotelList, "hotel", _userData.user.id),
                    )
                  ],
                );
              },
            ),
            FutureBuilder<List<Marker>>(
              future: _data.getUserFavoriterBar(_userData.user.id),
              builder: (context, snapshot) {
                barList = snapshot.data;
                return ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(barList == null
                      ? "Loading"
                      : "Bars: " + barList.length.toString()),
                  children: [
                    Column(
                      children: buildItem(barList, "bar", _userData.user.id),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  buildItem(List<Marker> markers, String category, String userId) {
    List<Widget> columnContent = [];

    if (markers != null) {
      for (Marker marker in markers) {
        columnContent.add(
          ListTile(
            title: Text(marker.infoWindow.title),
            subtitle: Text(marker.position.toString()),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MarkerTab(
                          name: marker.infoWindow.title,
                          category: category,
                          markerId: marker.markerId.value,
                          userId: userId,
                        ))).then((value) {
              setState(() {});
            }),
          ),
        );
      }
    } else {
      columnContent.add(Container());
    }
    return columnContent;
  }

  logOut(_context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uitloggen'),
          content: Container(
            height: MediaQuery.of(context).size.height / 7,
            child: Column(
              children: [
                Text("Weet u zeker dat u wilt uitloggen?"),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    FlatButton(
                      child: Text("Annuleren"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Uitloggen",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                        _auth.signOut(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
