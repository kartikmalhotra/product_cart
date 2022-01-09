import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class AppSwipePaginationBuilder extends SwiperPlugin {
  /// Active paginate color
  final Color? activeColor;

  /// In-Active paginate color
  final Color? inActiveColor;

  /// Size of the active paginate, Defaults to 10.0
  final double activeSize;

  /// Size of the in-active paginate, Defaults to 10.0
  final double inActiveSize;

  /// Space between each paginates, Defaults to 3.0
  final double space;

  /// To show the paginate in severity colors
  final bool showSeverityColor;

  /// List of all the paginate colors in order of there appearance
  final List<Color> severityColors;

  final Key? key;

  AppSwipePaginationBuilder(
      {this.activeColor,
      this.inActiveColor,
      this.activeSize = 10.0,
      this.inActiveSize = 10.0,
      this.space = 3.0,
      this.showSeverityColor = false,
      this.severityColors = const [],
      this.key});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    /// Get the total number of items in the pagination
    int itemCount = config.itemCount!;

    /// Get the index of the active paginate
    int? activeIndex = config.activeIndex;

    List<Widget> list = [];

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      list.add(
        Container(
          key: Key("pagination_$i"),
          margin: EdgeInsets.all(space),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(inActiveSize)),
            child: Container(
              color: showSeverityColor
                  ? severityColors[i]
                  : active
                      ? activeColor
                      : inActiveColor,
              width: active ? activeSize * 2 : inActiveSize,
              height: active ? activeSize : inActiveSize,
            ),
          ),
        ),
      );
    }
    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Wrap(
              key: key,
              alignment: WrapAlignment.center,
              children: list,
            ),
          ),
        ],
      );
    }
  }
}
