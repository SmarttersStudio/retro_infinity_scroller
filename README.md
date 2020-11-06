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
  itemBuilder: (context, index)=>Card(
      child: Column(
        children: <Widget>[
          Image.network(
            _photos[index].thumbnailUrl,
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: 160,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_photos[index].title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    )
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
  itemBuilder: (context, index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(
            _photos[index].thumbnailUrl,
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: 160,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_photos[index].title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  },
)
```
####
####
####
####
