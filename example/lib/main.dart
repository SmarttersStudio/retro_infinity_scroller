import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:retro_infinity_scroll/retro_infinity_scroll.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: InfiniteScrollPage(),
        appBar: AppBar(title: Text("Retro Scroll Page")),
      )));
}

class InfiniteScrollPage extends StatefulWidget {
  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  bool _hasMore;
  bool _error;
  bool _loading;
  final int _limit = 10;
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
      onLoadMore: () => fetchPhotos(),
      refreshIndicatorType: RefreshIndicatorType.ios,
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

class Photo {
  final String title;
  final String thumbnailUrl;
  Photo(this.title, this.thumbnailUrl);
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json["title"], json["thumbnailUrl"]);
  }
  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}
