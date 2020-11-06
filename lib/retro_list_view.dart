import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'enums.dart';

class RetroListView extends StatefulWidget {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsetsGeometry padding;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String restorationId;
  final Clip clipBehavior;

  /// To Display an empty screen when the list is empty
  ///
  /// Defaults to yielding a Text wrapped with Center with Text 'No Data Found'
  final Widget emptyWidget;

  /// To Display an error screen when any sort of error is fetched from the API
  ///
  /// Defaults to yielding a Text wrapped with Center with Text 'Some error occurred'
  final Widget errorWidget;

  /// To Display a loading screen when the data is getting fetched from the API
  ///
  /// Defaults to yielding a CircularProgressIndicator wrapped with Center
  final Widget loadingWidget;

  /// To Display a loading widget below the last row of the list
  /// when the more data is getting fetched
  ///
  /// Defaults to yielding a CircularProgressIndicator wrapped with Center
  final Widget loadMoreWidget;

  /// Set true if you have more data to load
  /// else set false
  /// Make sure to implement the property as it is a
  /// [Required Parameter]
  final bool hasMore;
  final double itemExtent;

  /// Function to handle load more
  /// It is fired when the user reaches the last tile of the list by scrolling
  /// No @params required
  /// Api call to load more should be handled inside this callback
  final Function onLoadMore;

  /// Enumerated [InfiniteScrollStateType] to be used
  /// It determines the current state of the list
  /// For Example if currently your data is getting fetched and you're waiting
  /// then set the state as [InfiniteScrollStateType.loading]
  /// Make sure to implement the property as it is a ['Required Parameter']
  final InfiniteScrollStateType stateType;

  /// Enumerated [RefreshIndicatorType] to be used
  /// It determines the type of Refresh Indicator you want to use
  /// You can use the default android style & ios style indicators and also you are
  /// enabled with a custom type where you can create your own indicator widget
  ///
  /// Make sure if you're using the custom type then you must provide the [refreshIndicatorBuilder]
  ///
  /// For Example you want to use the default android style then you just need to simply
  /// pass the [refreshIndicatorType] as [RefreshIndicatorType.android], same for ios
  /// as [RefreshIndicatorType.ios] and for
  /// custom as [RefreshIndicatorType.custom] and must pass the [refreshIndicatorBuilder]
  final RefreshIndicatorType refreshIndicatorType;

  ///Only to be used if you're using the [refreshIndicatorType] as [RefreshIndicatorType.custom]
  /// Signature for a builder that can create a different widget to show in the
  /// refresh indicator space depending on the current state of the refresh
  /// control and the space available.
  final RefreshControlIndicatorBuilder refreshIndicatorBuilder;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final Function onRefresh;
  final Key key;

  RetroListView(
      {this.key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      this.onLoadMore,
      this.refreshIndicatorType,
      this.refreshIndicatorBuilder,
      @required this.itemBuilder,
      this.onRefresh,
      @required this.itemCount,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.itemExtent,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.restorationId,
      this.clipBehavior = Clip.hardEdge,
      @required this.hasMore,
      this.emptyWidget = const Center(child: Text('No Data Found')),
      this.errorWidget = const Center(child: Text('Some error occurred')),
      this.loadingWidget = const Center(child: CircularProgressIndicator()),
      this.loadMoreWidget = const Center(child: CircularProgressIndicator()),
      @required this.stateType})
      : assert(itemBuilder != null &&
            itemCount != null &&
            stateType != null &&
            hasMore != null &&
            itemCount >= 0),
        assert(
            refreshIndicatorType != RefreshIndicatorType.custom ||
                refreshIndicatorBuilder != null,
            'Refresh indicator builder is required while using RefreshIndicatorType.custom'),
        super(key: key);

  @override
  _RetroListViewState createState() => _RetroListViewState();
}

class _RetroListViewState extends State<RetroListView> {
  ///A Scroll Controller to manage the scroll to implement the [widget.onLoadMore] callback
  ScrollController _controller;

  ///Determines the extent to which the indicator can be dragged
  static const _offsetToArmed = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels &&
          widget.hasMore) {
        // The user has scrolled to the list tile of the list and if
        // there is more to load
        // onLoadMore function is called
        widget.onLoadMore?.call();
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refreshIndicatorType == RefreshIndicatorType.android) {
      // If the user wants to use the default android style refresh indicator
      return RefreshIndicator(
          child: _getWidget(),
          onRefresh: () async {
            return Future.delayed(const Duration(seconds: 2));
          });
    } else {
      // If the user wants to use the default ios style or custom refresh indicator
      // If IOS style is used then no [refreshIndicatorBuilder] is passed and a default
      // cupertino style refresh indicator widget is built
      // If custom style is used then [refreshIndicatorBuilder] is definitely passed
      // and whatever the widget is passed is just built
      return CustomScrollView(
        controller: _controller,
        physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
              refreshIndicatorExtent: _offsetToArmed,
              refreshTriggerPullDistance: _offsetToArmed,
              onRefresh: () async {
                await widget.onRefresh?.call();
                return Future.delayed(const Duration(seconds: 2));
              },
              builder: widget.refreshIndicatorBuilder ??
                  CupertinoSliverRefreshControl.buildRefreshIndicator),
          _getWidget(isScrollable: false),
        ],
      );
    }
  }

  /// returns the [ListView] widget where the fetched data are shown
  ///
  /// Gets called only if the [widget.stateType] is [InfiniteScrollStateType.loaded]
  _getList(isScrollable, ListView listView) {
    if (isScrollable) return listView;
    return SliverToBoxAdapter(
      child: listView,
    );
  }

  /// returns the [widget.emptyWidget] or [widget.loadingWidget] or [widget.errorWidget]
  ///
  /// Gets called only if the [widget.stateType] is not [InfiniteScrollStateType.loaded]
  _getOtherWidgets(isScrollable, Widget widget) {
    if (isScrollable) return widget;
    return SliverFillRemaining(
      child: widget,
    );
  }

  /// return the main body widget
  Widget _getWidget({isScrollable = true}) {
    if (widget.stateType == InfiniteScrollStateType.loading) {
      return _getOtherWidgets(isScrollable,
          widget.loadingWidget ?? Center(child: CircularProgressIndicator()));
    } else if (widget.stateType == InfiniteScrollStateType.error) {
      return _getOtherWidgets(isScrollable,
          widget.errorWidget ?? Center(child: Text('Some error occurred')));
    } else if (widget.itemCount == 0) {
      return _getOtherWidgets(isScrollable,
          widget.emptyWidget ?? Center(child: Text('No Data Found')));
    } else {
      return _getList(
          isScrollable,
          ListView.builder(
            key: widget.key,
            itemBuilder: (ctx, index) {
              if (index == widget.itemCount && widget.hasMore)
                // returns the loadmore widget when the loadmore is in progress
                return widget.loadMoreWidget ??
                    Center(child: CircularProgressIndicator());
              return widget.itemBuilder?.call(ctx, index);
            },
            itemCount: widget.itemCount + (widget.hasMore ? 1 : 0),
            padding: widget.padding,
            physics:
                isScrollable ? widget.physics : NeverScrollableScrollPhysics(),
            shrinkWrap: isScrollable ? widget.shrinkWrap : true,
            scrollDirection: widget.scrollDirection,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            controller: isScrollable ? _controller : null,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            clipBehavior: widget.clipBehavior,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            primary: widget.primary,
            restorationId: widget.restorationId,
            reverse: widget.reverse,
            semanticChildCount: widget.semanticChildCount,
            itemExtent: widget.itemExtent,
          ));
    }
  }
}
