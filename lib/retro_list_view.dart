import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:retroinfinitescroll/enums/enums.dart';

class RetroListView extends StatelessWidget {
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
  final bool hasMore;
  final double itemExtent;
  final InfiniteScrollStateType stateType;

  RetroListView(
      {Key key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      @required this.itemBuilder,
      this.itemCount,
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
      this.emptyWidget,
      this.errorWidget,
      this.loadingWidget = const CircularProgressIndicator(),
      @required this.stateType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stateType == InfiniteScrollStateType.loading) {
      return Center(child: loadingWidget);
    } else if (stateType == InfiniteScrollStateType.error) {
      return errorWidget != null ? errorWidget : Text('Some error occurred');
    } else if (itemCount == 0) {
      return emptyWidget != null ? emptyWidget : Text('No Data Found');
    } else {
      return ListView.builder(
        key: key,
        itemBuilder: itemBuilder,
        itemCount: itemCount + (hasMore ? 1 : 0),
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        controller: controller,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        primary: primary,
        restorationId: restorationId,
        reverse: reverse,
        semanticChildCount: semanticChildCount,
        itemExtent: itemExtent,
      );
    }
  }
}
