# retro_infinity_scroll

A Flutter plugin to implement infinity scroll and inflact paginated data into a ListView

## Features
- Load more items when user reached the last
- Swipe to refresh (default and customization available)
- Custom Widget if list is empty or having errors
- Custom Widget while loading the data

## Getting Started

- Add ```retro_infinity_scroll``` as dependancy in ```pubspec.yaml```
```
dependencies:
  retro_infinity_scroll: <latest version>
```

- Import plugin class to your file
```
import 'package:retro_infinity_scroll/retro_infinity_scroll.dart';
```


<table>
  <tr><td> <b>Simple use</b> </td></tr>
  <tr>
    <td>
      <pre>
RetroListView(
  hasMore: false,
  itemCount: _photos.length,
  stateType: _loading
      ? InfiniteScrollStateType.loading
      : _error
        ? InfiniteScrollStateType.error
        : InfiniteScrollStateType.loaded,
  itemBuilder: (context, index)=>//Your item
)</code></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=300></tr>
    <tr><td> <b>Using loadmore</b> </td></tr>
  <tr>
    <td>
      <pre>
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
),
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=300></tr>
    <tr><td> <b>Android style refresh</b> </td></tr>
   <tr>
    <td>
      <pre>
RetroListView(
  hasMore: _hasMore,
  itemCount: _photos.length,
  stateType: _loading
      ? InfiniteScrollStateType.loading
      : _error
          ? InfiniteScrollStateType.error
          : InfiniteScrollStateType.loaded,
  onLoadMore: () => fetchPhotos(), // Implements loadmore
  // To Implement Android Refresh Indicator
  refreshIndicatorType: RefreshIndicatorType.android,
      onRefresh: (){
        return Future.delayed(Duration(seconds: 2));
      },
  itemBuilder: (context, index)=>//<Your item>
)
      </pre></td><td><img src="https://github.com/SmarttersStudio/retro_infinity_scroller/blob/master/screenshots/android_refresh.jpg" width=300></tr>
    <tr><td> <b>IOS style refresh</b> </td></tr>
   <tr>
    <td>
      <pre>
RetroListView(
  hasMore: _hasMore,
  itemCount: _photos.length,
  physics: BouncingScrollPhysics(),
  // To be used in if running on Android Devices
  // and [refreshIndicatorType]
  // is [RefreshIndicatorType.ios] or [RefreshIndicatorType.custom]
  stateType: _loading
      ? InfiniteScrollStateType.loading
      : _error
          ? InfiniteScrollStateType.error
          : InfiniteScrollStateType.loaded,
  onLoadMore: () => fetchPhotos(), // Implements loadmore
  // To Implement IOS Sliver refresh indicator
  refreshIndicatorType: RefreshIndicatorType.ios,
  onRefresh: (){
    return Future.delayed(Duration(seconds: 2));
  },
  itemBuilder: (context, index)=>//<Your item>
)
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=300></tr>
    <tr><td> <b>Custom error idget</b> </td></tr>
   <tr>
    <td>
      <pre>
RetroListView(
  hasMore: false,
  itemCount: _photos.length,
  stateType: InfiniteScrollStateType.error,
  errorWidget: Center(child: Text('Some error occurred')),
  itemBuilder: (ctx, index)=>//<Your item>
  },
)      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=300></tr>
    <tr><td> <b>Custom empty widget</b> </td></tr>
   <tr>
    <td>
      <pre>
RetroListView(
  hasMore: false,
  itemCount: 0,
  stateType: InfiniteScrollStateType.loaded,
  emptyWidget: Center(child: Text('No data found')),
  itemBuilder: (ctx, index)=>//<Your item>
  },
)
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=300></tr>
  </table>
