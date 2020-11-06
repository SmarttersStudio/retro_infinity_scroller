import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retro_infinity_scroll/retro_infinity_scroll.dart';
import 'package:retroinfinityscroll_example/models/photo.dart';

/// A dummy implementation of plugin using the android refresh indicator
class InfinityScrollWithAndroidRefreshPage extends StatefulWidget {
  @override
  _InfinityScrollWithAndroidRefreshPageState createState() =>
      _InfinityScrollWithAndroidRefreshPageState();
}

class _InfinityScrollWithAndroidRefreshPageState
    extends State<InfinityScrollWithAndroidRefreshPage> {
  bool _error;
  bool _loading;
  List<Photo> _photos;

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("With Android Refresh")),
      body: RetroListView(
        hasMore: false,
        itemCount: _photos.length,
        stateType: _loading
            ? InfiniteScrollStateType.loading
            : _error
                ? InfiniteScrollStateType.error
                : InfiniteScrollStateType.loaded,
        refreshIndicatorType: RefreshIndicatorType
            .android, // To Implement Android Refresh Indicator
        itemBuilder: (ctx, position) {
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(
                  _photos[position].thumbnailUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  height: 160,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_photos[position].title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchPhotos() async {
    try {
      final response =
          await http.get("https://jsonplaceholder.typicode.com/photos?_page=1");
      List<Photo> fetchedPhotos = Photo.parseList(json.decode(response.body));
      setState(() {
        _loading = false;
        _photos.addAll(fetchedPhotos);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        if (_photos.isEmpty) {
          _error = true;
        } else {
          print(e);
        }
      });
    }
  }
}
