import 'package:bwys/config/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/utils/ui/ui_utils.dart';

class AppPersistentSliverDeligate extends SliverPersistentHeaderDelegate {
  final Widget expandedContent;
  final Widget persistentContent;
  final double expandedHeight;
  final bool showBackButton;
  final double? expandedContentTopPadding;

  AppPersistentSliverDeligate({
    required this.expandedContent,
    required this.persistentContent,
    this.expandedHeight = 200.0,
    this.showBackButton = true,
    this.expandedContentTopPadding,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: <Widget>[
        _getAppBarBackground(),
        _getAppFixedContent(context, shrinkOffset),
        _getAppExpandedContent(context, shrinkOffset),
        if (showBackButton) _getBackButtonIcon(context),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent =>
      AppScreenConfig.getStatusBarHeight()! + AppSpacing.topAppBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  Widget _getAppBarBackground() {
    return Container(
      height: AppScreenConfig.getStatusBarHeight()! + expandedHeight,
      width: double.infinity,
      decoration: BoxDecoration(),
    );
  }

  Widget _getAppFixedContent(BuildContext context, double shrinkOffset) {
    return Positioned(
      top: AppScreenConfig.getStatusBarHeight()! + AppSpacing.xs,
      left: showBackButton ? 50.0 : 16.0,
      child: Opacity(
        opacity: shrinkOffset / expandedHeight,
        child: persistentContent,
      ),
    );
  }

  Widget _getAppExpandedContent(BuildContext context, double shrinkOffset) {
    return Positioned(
      top: expandedContentTopPadding != null
          ? expandedContentTopPadding! - shrinkOffset
          : expandedHeight / 3 - shrinkOffset,
      left: AppSpacing.s,
      right: AppSpacing.s,
      bottom: AppSpacing.s,
      child: Opacity(
        opacity: (1 - shrinkOffset / expandedHeight),
        child: expandedContent,
      ),
    );
  }

  Widget _getBackButtonIcon(BuildContext context) {
    return Positioned(
      top: AppScreenConfig.getStatusBarHeight()! - AppSpacing.xs / 2,
      child: IconButton(
        icon: Icon(Application.platform == TargetPlatform.android
            ? Icons.arrow_back
            : Icons.arrow_back_ios),
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// This Delegate is used for showing Persistent TabBar along with SliverPersistentHeader
/// or sliverAppBar
///
///
/// Required Param: [AppTabs]
class AppPersistentSliverTabDelegate extends SliverPersistentHeaderDelegate {
  final AppTabs tabs;

  AppPersistentSliverTabDelegate({required this.tabs});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: tabs,
    );
  }

  @override
  double get maxExtent => 55.0;

  @override
  double get minExtent => 55.0;

  @override
  bool shouldRebuild(AppPersistentSliverTabDelegate oldDelegate) => false;
}

/// This Delegate is used for showing Persistent Widget along with SliverPersistentHeader
/// or sliverAppBar
///
///
/// Required Param: [Widget]
class AppPersistentSliverWidgetDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;

  AppPersistentSliverWidgetDelegate({
    required this.widget,
    required this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      child: widget,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(AppPersistentSliverWidgetDelegate oldDelegate) => false;
}
