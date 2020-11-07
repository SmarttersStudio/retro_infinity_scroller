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
)</pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=400></tr>
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
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=400></tr>
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
  refreshIndicatorType: RefreshIndicatorType.android, // To Implement Android Refresh Indicator
      onRefresh: (){
        return Future.delayed(Duration(seconds: 2));
      },
  itemBuilder: (context, index)=>//<Your item>
)
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=400></tr>
    <tr><td> <b>IOS style refresh</b> </td></tr>
   <tr>
    <td>
      <pre>
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
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=400></tr>
    <tr><td> <b>TITLE</b> </td></tr>
   <tr>
    <td>
      <pre>
     CODE
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=400></tr>
    <tr><td> <b>TITLE</b> </td></tr>
   <tr>
    <td>
      <pre>
  CODE
      </pre></td><td><img src="https://via.placeholder.com/480x853.png/FD007B/FFFFFF?text=Hello" width=400></tr>
  </table>