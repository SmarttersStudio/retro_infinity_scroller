import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retro_infinity_scroll/retro_infinity_scroll.dart';
import 'package:retroinfinityscroll_example/models/photo.dart';

/// A dummy implementation of plugin using the custom refresh indicator and loadmore
class InfinityScrollWithCustomRefreshAndLoadMorePage extends StatefulWidget {
  @override
  _InfinityScrollWithCustomRefreshAndLoadMorePageState createState() =>
      _InfinityScrollWithCustomRefreshAndLoadMorePageState();
}

class _InfinityScrollWithCustomRefreshAndLoadMorePageState
    extends State<InfinityScrollWithCustomRefreshAndLoadMorePage> {
  bool _hasMore = false; // determines if more to load
  bool _error = false;
  bool _loading = false;
  final int _limit = 10; // max count of data to show on the list
  List<Photo> _photos = [];

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("With Custom Refresh and loadmore")),
      body: RetroInfinityScroll(
        hasMore: _hasMore,
        itemCount: _photos.length,
        physics:
            BouncingScrollPhysics(), // To be used in if running on Android Devices
        // and [refreshIndicatorType]
        // is [RefreshIndicatorType.ios] or [RefreshIndicatorType.custom]
        stateType: _loading
            ? InfiniteScrollStateType.loading
            : _error
                ? InfiniteScrollStateType.error
                : InfiniteScrollStateType.loaded,
        onLoadMore: () => fetchPhotos(), // Implements loadmore
        refreshIndicatorType: RefreshIndicatorType
            .custom, // To Implement Custom Refresh Indicator
        refreshIndicatorBuilder: (context, refreshState, pulledExtent,
            refreshTriggerPullDistance, refreshIndicatorExtent) {
          return Container(
              height: 200,
              color: const Color(0xFFF5F5F5),
              width: double.infinity,
              alignment: Alignment.center,
              child: Icon(
                Icons.camera,
                color: Colors.black54,
              ));
        },
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
        _hasMore = fetchedPhotos.length == _limit;
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
