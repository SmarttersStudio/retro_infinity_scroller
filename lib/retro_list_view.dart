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
  final Widget emptyWidget;
  final Widget errorWidget;
  final Widget loadingWidget;
  final Widget loadMoreWidget;
  final bool hasMore;
  final double itemExtent;
  final Function onLoadMore;
  final InfiniteScrollStateType stateType;
  final RefreshIndicatorType refreshIndicatorType;
  final RefreshControlIndicatorBuilder refreshIndicatorBuilder;
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
  ScrollController _controller;

  static const _offsetToArmed = 100.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels &&
          widget.hasMore) {
        widget.onLoadMore?.call();
//        print('load more');
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
      return RefreshIndicator(
          child: _getWidget(),
          onRefresh: () async {
            return Future.delayed(const Duration(seconds: 2));
          });
    } else {
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

  _getList(isScrollable, ListView listView) {
    if (isScrollable) return listView;
    return SliverToBoxAdapter(
      child: listView,
    );
  }

  _getOtherWidgets(isScrollable, Widget widget) {
    if (isScrollable) return widget;
    return SliverFillRemaining(
      child: widget,
    );
  }

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
