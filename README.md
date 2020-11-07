# retro_infinity_scroll

A Flutter plugin to implement infinity scroll and inflact paginated data into a ListView

## Getting Started

- Add ```retro_infinity_scroll``` as dependancy in ```pubspec.yaml```
```
dependencies:
  retro_infinity_scroll: <latest version>
```

- Import plugin class to your file
```import 'package:retro_infinity_scroll/retro_infinity_scroll.dart';```

#### Simple use
```dart
RetroListView(
  hasMore: false,
  itemCount: _photos.length,
  stateType: _loading
      ? InfiniteScrollStateType.loading
      : _error
        ? InfiniteScrollStateType.error
        : InfiniteScrollStateType.loaded,
  itemBuilder: (context, index)=>//<Your item>
)
```
#### Using of loadmore
```dart
RetroListView(
  hasMore: _hasMore,
  itemCount: _photos.length,
  stateType: _isLoading
      ? InfiniteScrollStateType.loading
      : _error
          ? InfiniteScrollStateType.error
          : InfiniteScrollStateType.loaded,
  onLoadMore: () => fetchPhotos(), // Implements loadmore
  itemBuilder: (context, index)=>//<Your item>
)
```
#### Android style refresh
```dart
RetroListView(
  hasMore: _hasMore,
  itemCount: _photos.length,
  stateType: _loading
      ? InfiniteScrollStateType.loading
      : _error
          ? InfiniteScrollStateType.error
          : InfiniteScrollStateType.loaded,
  onLoadMore: () => fetchPhotos(), // Implements loadmore
  refreshIndicatorType: RefreshIndicatorType.android, // To Implement Android Refresh Indicator
      onRefresh: (){
        return Future.delayed(Duration(seconds: 2));
      },
  itemBuilder: (context, index)=>//<Your item>
)
```
#### IOS style refresh
```dart
RetroListView(
  hasMore: _hasMore,
  itemCount: _photos.length,
  physics: BouncingScrollPhysics(), /// To be used in if running on Android Devices
  /// and [refreshIndicatorType]
  /// is [RefreshIndicatorType.ios] or [RefreshIndicatorType.custom]
  stateType: _loading
      ? InfiniteScrollStateType.loading
      : _error
          ? InfiniteScrollStateType.error
          : InfiniteScrollStateType.loaded,
  onLoadMore: () => fetchPhotos(), // Implements loadmore
  refreshIndicatorType: RefreshIndicatorType.ios, // To Implement IOS Sliver refresh indicator
  onRefresh: (){
    return Future.delayed(Duration(seconds: 2));
  },
  itemBuilder: (context, index)=>//<Your item>
)
```
#### Custom refresh
```dart

```
