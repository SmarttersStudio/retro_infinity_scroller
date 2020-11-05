import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:retroinfinitescroll/enums/enums.dart';
import 'package:retroinfinitescroll/retro_list_view.dart';

class InfiniteScrollPage extends StatefulWidget {
  @override
  _InfiniteScrollPageState createState() => _InfiniteScrollPageState();
}

class _InfiniteScrollPageState extends State<InfiniteScrollPage> {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultPhotosPerPageCount = 10;
  List<Photo> _photos;
  final int _loadMoreThreshold = 5;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Photos App")),
      body: RetroListView(
        hasMore: _hasMore,
        itemCount: _photos.length,
        stateType: _loading
            ? InfiniteScrollStateType.loading
            : _error
                ? InfiniteScrollStateType.error
                : InfiniteScrollStateType.loaded,
        itemBuilder: (c, index) {
          if (index == _photos.length - _loadMoreThreshold) {
            fetchPhotos();
          }
//          if (_hasMore) {
//            fetchPhotos();
//          }
          if (index == _photos.length) {
            if (_error) {
              return Center(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    _loading = true;
                    _error = false;
                    fetchPhotos();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Error while loading photos, tap to try agin"),
                ),
              ));
            } else {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          final Photo photo = _photos[index];
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(
                  photo.thumbnailUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  height: 160,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(photo.title,
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
      final response = await http.get(
          "https://jsonplaceholder.typicode.com/photos?_page=$_pageNumber");
      List<Photo> fetchedPhotos = Photo.parseList(json.decode(response.body));
      setState(() {
        _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;
        _loading = false;
        _pageNumber = _pageNumber + 1;
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
