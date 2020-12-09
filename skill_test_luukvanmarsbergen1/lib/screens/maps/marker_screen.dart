import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_imports/services/data.dart';

class MarkerTab extends StatefulWidget {
  final String name;
  final String category;
  final String markerId;
  final String userId;
  MarkerTab({Key key, this.name, this.category, this.markerId, this.userId})
      : super(key: key);

  @override
  _MarkerTab createState() => _MarkerTab();
}

class _MarkerTab extends State<MarkerTab> {
  DataService _data = DataService();
  bool favorited = false;

  @override
  void initState() {
    checkFavoriteMarker(widget.userId);
    super.initState();
  }

  checkFavoriteMarker(String userId) async {
    favorited = await _data.checkFavoriteMarker(
        widget.markerId, widget.category, userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.toUpperCase()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
                favorited ? Icons.favorite : Icons.favorite_border_outlined),
            onPressed: () => favoriteMarker(widget.userId),
          )
        ],
      ),
      body: Center(
        child: Text(widget.name),
      ),
    );
  }

  favoriteMarker(String userId) async {
    if (!favorited) {
      _data.addFavoriteMarker(
        userId,
        widget.category,
        widget.markerId,
      );
    } else {
      _data.removeFavoriteMarker(
        userId,
        widget.category,
        widget.markerId,
      );
    }
    checkFavoriteMarker(widget.userId);
  }
}
