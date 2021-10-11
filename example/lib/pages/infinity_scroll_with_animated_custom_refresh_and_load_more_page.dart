import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:retro_infinity_scroll/retro_infinity_scroll.dart';
import 'package:retroinfinityscroll_example/models/photo.dart';

/// A dummy implementation of plugin using the animated custom refresh indicator and loadmore
class InfinityScrollWithAnimatedCustomRefreshAndLoadMorePage
    extends StatefulWidget {
  @override
  _InfinityScrollWithAnimatedCustomRefreshAndLoadMorePageState createState() =>
      _InfinityScrollWithAnimatedCustomRefreshAndLoadMorePageState();
}

class _InfinityScrollWithAnimatedCustomRefreshAndLoadMorePageState
    extends State<InfinityScrollWithAnimatedCustomRefreshAndLoadMorePage>
    with SingleTickerProviderStateMixin {
  bool _hasMore = true; // determines if more to load
  bool _error = false;
  bool _loading = true;
  final int _limit = 10; // max count of data to show on the list
  List<Photo> _photos = [];
  static final _logoTween = CurveTween(curve: Curves.easeInOut);
  AnimationController? _logoController;
  RefreshIndicatorMode? _prevState;

  void _startLogoAnimation() {
    _logoController!.repeat(reverse: true);
  }

  void _stopLogoAnimation() {
    _logoController!
      ..stop()
      ..animateTo(0.0, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _logoController!.dispose();
    super.dispose();
  }

  static const _offsetToArmed = 100.0;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _hasMore = true;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    final plane = AnimatedBuilder(
      animation: _logoController!,
      child: Lottie.asset('assets/refresh_anim.json', animate: true),
      builder: (BuildContext? context, Widget? child) {
        return Transform.translate(
            offset: Offset(
                0.0, 10 * (0.5 - _logoTween.transform(_logoController!.value))),
            child: child);
      },
    );
    return Scaffold(
      appBar: AppBar(title: Text("With Animated Custom Refresh and loadmore")),
      body: RetroInfinityScroll(
        physics:
            BouncingScrollPhysics(), // To be used in if running on Android Devices
        // and [refreshIndicatorType]
        // is [RefreshIndicatorType.ios] or [RefreshIndicatorType.custom]
        hasMore: _hasMore,
        itemCount: _photos.length,
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
          if (_prevState == RefreshIndicatorMode.armed &&
              refreshState == RefreshIndicatorMode.refresh) {
            _startLogoAnimation();
          } else if (_prevState == RefreshIndicatorMode.refresh &&
              refreshState == RefreshIndicatorMode.done) {
            _stopLogoAnimation();
          }
          _prevState = refreshState;
          return Container(
              height: _offsetToArmed * refreshTriggerPullDistance,
              color: const Color(0xFFF5F5F5),
              width: double.infinity,
              alignment: Alignment.center,
              child: plane);
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
