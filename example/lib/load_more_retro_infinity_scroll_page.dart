import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:retro_infinity_scroll/enums.dart';
import 'package:retro_infinity_scroll/retro_list_view.dart';
import 'package:http/http.dart' as http;
import 'photo.dart';

class LoadMoreInfinityScrollPage extends StatefulWidget {
  @override
  _LoadMoreInfinityScrollPageState createState() =>
      _LoadMoreInfinityScrollPageState();
}

class _LoadMoreInfinityScrollPageState
    extends State<LoadMoreInfinityScrollPage> {
  bool _hasMore; // determines if more to load
  bool _error;
  bool _loading;
  final int _limit = 10; // max count of data to show on the list
  List<Photo> _photos;

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
    return RetroListView(
      hasMore: _hasMore,
      itemCount: _photos.length,
      stateType: _loading
          ? InfiniteScrollStateType.loading
          : _error
              ? InfiniteScrollStateType.error
              : InfiniteScrollStateType.loaded,
      onLoadMore: () => fetchPhotos(), // Implements loadmore
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
