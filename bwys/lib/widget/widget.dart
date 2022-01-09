import 'package:bwys/config/screen_config.dart';
import 'package:bwys/config/themes/light_theme.dart';
import 'package:bwys/shared/models/pnm_common_model.dart';
import 'package:bwys/utils/ui/app_dialogs.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/chips_choice/model/model.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class AppBottomNavigationBar extends StatelessWidget {
  final void Function(int) currentIndex;

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: LightAppColors.blackColor,
      elevation: 0.0,
      child: Container(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppBottomNavItem(
              icon: Icon(Icons.home),
              label: 'Home',
              index: 0,
              value: (int index) {},
            ),
            AppBottomNavItem(
              icon: Icon(Icons.shop),
              label: 'Shop',
              index: 1,
              value: (int index) {},
            ),
            AppBottomNavItem(
              icon: Icon(Icons.live_tv),
              label: 'Live',
              index: 2,
              value: (int index) {},
            ),
            AppBottomNavItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              index: 3,
              value: (int index) {},
            )
          ],
        ),
      ),
    );
  }
}

class AppBottomNavItem extends StatelessWidget {
  final String label;
  final Icon icon;
  final int index;
  final void Function(int) value;

  const AppBottomNavItem({
    required this.label,
    required this.icon,
    required this.index,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 3.0),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: LightAppColors.cardBackground))
        ],
      ),
    );
  }
}

/// This class is used to make the primary buttons in the application.
/// Button type: Raised button with text and icon button with text.
/// Required parameters: Text, callback when the button is pressed.
class AppElevatedButton extends StatelessWidget {
  final IconData? icon;
  final String? message;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final Color? color;
  final double? minWidth;
  final Color? textColor;
  final Widget? leadingWidget;
  final TextStyle? textStyle;

  const AppElevatedButton({
    required this.message,
    required this.onPressed,
    Key? key,
    this.icon,
    this.borderRadius,
    this.minWidth,
    this.color,
    this.textColor,
    this.leadingWidget,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildRaisedButton(context);
  }

  Widget _buildRaisedButton(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth ?? AppScreenConfig.getScreenWidth()! * 0.4,
      height: 40.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: minWidth ?? AppScreenConfig.getScreenWidth()! * 0.4,
              minHeight: 40.0,
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: (message?.isNotEmpty ?? false)
                  ? (icon == null && leadingWidget == null)
                      ? _getButtonWithTextOnly(message!, context)
                      : (leadingWidget == null)
                          ? _getButtonWithIconText(icon, message!, context)
                          : _getButtonWithLeadingText(
                              leadingWidget!, message!, context)
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getButtonWithIconText(
      IconData? icon, String message, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: LightAppColors.primaryButtonTextColor),
        const AppSizedBoxSpacing(
          heightSpacing: 0.0,
          widthSpacing: 12.0,
        ),
        Flexible(
          child: AppText(
            message.toUpperCase(),
            textAlign: TextAlign.center,
            style: color == null
                ? TextStyle(color: LightAppColors.primaryButtonTextColor)
                : (Theme.of(context).brightness == Brightness.light)
                    ? TextStyle(color: LightAppColors.primaryButtonTextColor)
                    : TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _getButtonWithTextOnly(String message, BuildContext context) {
    return AppText(
      message.toUpperCase(),
      textAlign: TextAlign.center,
      style: getTextStyle(context),
    );
  }

  TextStyle? getTextStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle;
    } else if (textColor == null) {
      return color == null
          ? TextStyle(color: LightAppColors.primaryButtonTextColor)
          : (Theme.of(context).brightness == Brightness.light)
              ? TextStyle(color: LightAppColors.primaryButtonTextColor)
              : TextStyle(color: Theme.of(context).primaryColor);
    } else {
      return TextStyle(color: textColor);
    }
  }

  Widget _getButtonWithLeadingText(
      Widget leading, String message, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leading,
        const AppSizedBoxSpacing(
          heightSpacing: 0.0,
          widthSpacing: 12.0,
        ),
        Flexible(
          child: AppText(
            message.toUpperCase(),
            textAlign: TextAlign.center,
            style: color == null
                ? TextStyle(color: LightAppColors.primaryButtonTextColor)
                : (Theme.of(context).brightness == Brightness.light)
                    ? TextStyle(color: LightAppColors.primaryButtonTextColor)
                    : TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String? message;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? maxWidth;

  const AppTextButton({
    required this.message,
    required this.onPressed,
    Key? key,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget flatButton;
    if (icon == null) {
      flatButton = TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          primary:
              (backgroundColor != null) ? backgroundColor : Colors.transparent,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? AppScreenConfig.screenWidth / 2,
          ),
          child: AppText(message,
              textAlign: TextAlign.center,
              style: (textStyle != null)
                  ? textStyle
                  : (textColor != null)
                      ? Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: textColor)
                      : Theme.of(context).textTheme.button),
        ),
      );
    } else if ((icon != null) && (message!.isNotEmpty)) {
      flatButton = TextButton.icon(
        onPressed: onPressed,
        icon: icon!,
        label: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? AppScreenConfig.screenWidth / 2,
          ),
          child: AppText(message,
              style: (textStyle != null)
                  ? textStyle
                  : (textColor != null)
                      ? Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: textColor)
                      : Theme.of(context).textTheme.button),
        ),
      );
    } else {
      flatButton = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          icon!,
          AppText(
            message,
            style: (textStyle != null)
                ? textStyle
                : (textColor != null)
                    ? Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: textColor)
                    : Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Theme.of(context).primaryColor),
          )
        ],
      );
    }
    return flatButton;
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String? message;
  final VoidCallback onPressed;
  final Color? borderAndTextColor;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  const AppOutlinedButton({
    required this.message,
    required this.onPressed,
    Key? key,
    this.borderAndTextColor,
    this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: padding ??
            const EdgeInsets.symmetric(
                vertical: AppSpacing.xs, horizontal: AppSpacing.m),
        side: BorderSide(
            width: 0.9,
            color: (borderAndTextColor != null)
                ? borderAndTextColor!
                : Theme.of(context).primaryColor //Color of the border
            ),
      ),
      onPressed: onPressed,
      child: (icon != null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                icon!,
                const AppSizedBoxSpacing(
                    heightSpacing: 0.0, widthSpacing: 12.0),
                Flexible(
                  child: _getOutlineButtonText(context),
                ),
              ],
            )
          : _getOutlineButtonText(context),
    );
  }

  Widget _getOutlineButtonText(BuildContext context) {
    return AppText(
      message!.toUpperCase(),
      style: (borderAndTextColor != null)
          ? Theme.of(context)
              .textTheme
              .button!
              .copyWith(color: borderAndTextColor)
          : Theme.of(context)
              .textTheme
              .button!
              .copyWith(color: Theme.of(context).primaryColor),
      textAlign: TextAlign.center,
    );
  }
}

/// This class is used to make the circular icon raised button.
/// Required parameters: IconData and callback when the button is pressed.
/// if fillColor is not provided gradient is used instead
class CircularIconRaisedButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? circleRadius;
  final double? iconSize;
  final Color? fillColor;

  const CircularIconRaisedButton({
    required this.icon,
    required this.onPressed,
    Key? key,
    this.circleRadius,
    this.iconSize,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCircularIconRaisedButton(context);
  }

  Widget _buildCircularIconRaisedButton(BuildContext context) {
    return ClipOval(
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        child: SizedBox(
          width: circleRadius ?? 56,
          height: circleRadius ?? 56,
          child: Container(
            decoration: getBoxDecoration(fillColor),
            child: Center(
              child: Icon(
                icon,
                color: LightAppColors.primaryButtonTextColor,
                size: iconSize ?? 35.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration getBoxDecoration(Color? fillColor) {
    return BoxDecoration(color: fillColor);
  }
}

/// This class is used to make the circular icon raised button.
/// Required parameters: IconData and callback when the button is pressed.
class CircularBorderIconRaisedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double? circleRadius;
  final double? iconSize;

  const CircularBorderIconRaisedButton({
    required this.icon,
    required this.onPressed,
    Key? key,
    this.circleRadius,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCircularBorderIconRaisedButton(context);
  }

  Widget _buildCircularBorderIconRaisedButton(BuildContext context) {
    return ClipOval(
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        child: SizedBox(
          width: circleRadius ?? 32,
          height: circleRadius ?? 32,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: LightAppColors.primary,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: LightAppColors.primary,
                size: iconSize ?? 26.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// This class is used to make the circular icon raised button.
/// Required parameters: IconData and callback when the button is pressed.
class CircularSelectableIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double? circleRadius;
  final double? iconSize;
  final bool selected;

  const CircularSelectableIconButton({
    required this.icon,
    required this.onPressed,
    Key? key,
    this.circleRadius,
    this.iconSize,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCircularBorderIconRaisedButton(context);
  }

  Widget _buildCircularBorderIconRaisedButton(BuildContext context) {
    return ClipOval(
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        child: SizedBox(
          width: circleRadius ?? 32,
          height: circleRadius ?? 32,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    selected ? LightAppColors.light : LightAppColors.greyColor,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: selected
                    ? LightAppColors.primaryButtonTextColor
                    : LightAppColors.greyColor,
                size: iconSize ?? 26.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppCircularProgressLoader extends StatelessWidget {
  final double strokeWidth;
  final Color? strokeColor;

  const AppCircularProgressLoader({this.strokeWidth = 4.0, this.strokeColor});

  @override
  Widget build(BuildContext context) {
    return _buildCircularProgressLoader(context);
  }

  Widget _buildCircularProgressLoader(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: (strokeColor != null)
          ? AlwaysStoppedAnimation<Color?>(strokeColor)
          : AlwaysStoppedAnimation<Color>(LightAppColors.bannerColorLight),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final bool addCircularBackground;
  final Color circularBackgroundColor;
  final Color? materialBackgroundColor;
  final bool addCircularBorderToMaterial;
  final String? tooltip;
  final double? iconSize;
  final bool removeTagertExtraPadding;
  final BoxConstraints? constraints;

  const AppIconButton({
    required this.icon,
    required this.onPressed,
    Key? key,
    this.iconColor,
    this.addCircularBackground = false,
    this.circularBackgroundColor = Colors.transparent,
    this.materialBackgroundColor,
    this.addCircularBorderToMaterial = false,
    this.tooltip,
    this.iconSize,
    this.removeTagertExtraPadding = false,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return _buildIconButton(context);
  }

  Widget _buildIconButton(BuildContext context) {
    return Material(
      color: materialBackgroundColor ?? Colors.transparent,
      shape: (addCircularBorderToMaterial)
          ? const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
            )
          : null,
      child: Ink(
        decoration: (addCircularBackground) ? _getCircularDecoration() : null,
        child: (removeTagertExtraPadding)
            ? Container(
                width: iconSize != null ? iconSize! * 1.5 : 36.0,
                padding: const EdgeInsets.all(0.0),
                child: _displayIconButton(context),
              )
            : _displayIconButton(context),
      ),
    );
  }

  ShapeDecoration _getCircularDecoration() {
    return ShapeDecoration(
      shape: const CircleBorder(),
      color: circularBackgroundColor,
    );
  }

  IconButton _displayIconButton(BuildContext context) {
    return IconButton(
      iconSize: iconSize ?? 24.0,
      padding: removeTagertExtraPadding
          ? const EdgeInsets.all(0.0)
          : const EdgeInsets.all(8.0),
      constraints: constraints ?? const BoxConstraints(),
      icon: Icon(icon),
      onPressed: onPressed,
      color: iconColor ?? Theme.of(context).primaryColor,
      disabledColor: LightAppColors.inactiveActionColor,
      tooltip: tooltip,
    );
  }
}

class AppTextIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final bool addCircularBackground;
  final Color? circularBackgroundColor;
  final String? tooltip;
  final double? iconSize;
  final String? text;
  final Color? textColor;

  const AppTextIconButton({
    required this.icon,
    required this.onPressed,
    Key? key,
    this.iconColor,
    this.addCircularBackground = false,
    this.circularBackgroundColor,
    this.tooltip,
    this.iconSize,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTextIconButton(context);
  }

  Widget _buildTextIconButton(BuildContext context) {
    return Ink(
      decoration: (addCircularBackground) ? _getCircularDecoration() : null,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).primaryColor,
              size: iconSize ?? 20,
            ),
            Text(
              '$text',
              style: Theme.of(context).textTheme.overline!.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    color: textColor ??
                        Theme.of(context).textTheme.bodyText1 as Color?,
                  ),
            )
          ],
        ),
      ),
    );
  }

  ShapeDecoration _getCircularDecoration() {
    return ShapeDecoration(
      shape: const CircleBorder(),
      color: circularBackgroundColor,
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;
  final Color? iconColor;
  final String? text;
  final Color? textColor;
  final bool addCircularBackground;
  final Color? circularBackgroundColor;
  final Color? materialBackgroundColor;
  final bool addCircularBorderToMaterial;
  final String? tooltip;
  final double? iconSize;
  final String? heroTag;

  const AppFloatingActionButton({
    required this.onPressed,
    Key? key,
    this.iconData,
    this.iconColor,
    this.text,
    this.textColor,
    this.addCircularBackground = false,
    this.circularBackgroundColor = Colors.transparent,
    this.materialBackgroundColor,
    this.addCircularBorderToMaterial = false,
    this.tooltip,
    this.iconSize,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return _buildFloatingActionButton(context);
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      heroTag: heroTag,
      backgroundColor: addCircularBackground
          ? circularBackgroundColor
          : Theme.of(context).floatingActionButtonTheme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: iconColor,
          ),
          Text(
            text!,
            style: Theme.of(context).textTheme.overline!.copyWith(
                  color: textColor,
                ),
          )
        ],
      ),
    );
  }
}

class AppBadgeIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final bool addCircularBackground;
  final Color circularBackgroundColor;
  final Color? materialBackgroundColor;
  final bool addCircularBorderToMaterial;
  final String? tooltip;
  final double? iconSize;
  final int badgeCount;

  const AppBadgeIconButton({
    required this.icon,
    required this.onPressed,
    Key? key,
    this.iconColor,
    this.addCircularBackground = false,
    this.circularBackgroundColor = Colors.transparent,
    this.materialBackgroundColor,
    this.addCircularBorderToMaterial = false,
    this.tooltip,
    this.iconSize,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBadgeIconButton(context);
  }

  Widget _buildBadgeIconButton(BuildContext context) {
    return Material(
      color: materialBackgroundColor ?? Colors.transparent,
      shape: (addCircularBorderToMaterial)
          ? const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
            )
          : null,
      child: Ink(
        decoration: (addCircularBackground) ? _getCircularDecoration() : null,
        child: Stack(
          children: <Widget>[
            IconButton(
              iconSize: iconSize ?? 24.0,
              icon: Icon(icon),
              onPressed: onPressed,
              color: iconColor ?? Theme.of(context).primaryColor,
              tooltip: tooltip,
            ),
            if (badgeCount != 0) _showBadge(context),
          ],
        ),
      ),
    );
  }

  ShapeDecoration _getCircularDecoration() {
    return ShapeDecoration(
      shape: const CircleBorder(),
      color: circularBackgroundColor,
    );
  }

  Widget _showBadge(BuildContext context) {
    return Positioned(
      right: 6.0,
      top: 6.0,
      child: Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        constraints: const BoxConstraints(
          minWidth: 18.0,
          minHeight: 18.0,
        ),
        child: Center(
          child: AppText(
            '$badgeCount',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}

class AppListTileItem extends StatelessWidget {
  final IconData iconData;
  final String? title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showTrailingIcon;
  final bool isDense;
  final Color? iconColor;
  final Color? titleColor;

  const AppListTileItem({
    required this.iconData,
    required this.title,
    required this.onTap,
    Key? key,
    this.subtitle,
    this.showTrailingIcon = true,
    this.isDense = false,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppListTile(context);
  }

  Widget _buildAppListTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: (iconColor != null) ? iconColor : Theme.of(context).primaryColor,
      ),
      title: AppText(
        title,
        style: (titleColor != null)
            ? Theme.of(context).textTheme.subtitle1!.copyWith(color: titleColor)
            : Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: (subtitle != null) ? AppText(subtitle) : null,
      trailing:
          (showTrailingIcon) ? const Icon(Icons.keyboard_arrow_right) : null,
      onTap: onTap,
      dense: isDense,
    );
  }
}

class AppListTileItemInfo extends StatelessWidget {
  final String? title;
  final String? infoText;
  final VoidCallback onTap;
  final bool showTrailingIcon;
  final Color? titleColor;

  const AppListTileItemInfo({
    required this.title,
    required this.onTap,
    required this.infoText,
    Key? key,
    this.showTrailingIcon = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppListTile(context);
  }

  Widget _buildAppListTile(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: AppText(
              title,
              style: (titleColor != null)
                  ? Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: titleColor)
                  : Theme.of(context).textTheme.subtitle1,
            ),
          ),
          if (infoText != null)
            InkWell(
              onTap: () {
                AppDialogs.showAppDialog(
                  context,
                  title: title,
                  description: infoText,
                );
              },
              child: const Icon(
                Icons.info_outline,
              ),
            ),
        ],
      ),
      trailing:
          (showTrailingIcon) ? const Icon(Icons.keyboard_arrow_right) : null,
      onTap: onTap,
    );
  }
}

class AppRecentSearchItem extends StatelessWidget {
  final String? title;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final bool showTrailingIcon;
  final Widget? trailingWidget;
  final Color? iconColor;
  final Color? titleColor;
  final String? heading;

  const AppRecentSearchItem({
    required this.title,
    this.onTap,
    Key? key,
    this.subtitle,
    this.showTrailingIcon = true,
    this.trailingWidget,
    this.iconColor,
    this.titleColor,
    this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppRecentSearchItem(context);
  }

  Widget _buildAppRecentSearchItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.s,
        top: AppSpacing.s,
        right: AppSpacing.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null)
            AppText(
              heading,
              style: Theme.of(context).textTheme.bodyText1,
              isSelectable: true,
            )
          else
            Container(),
          Row(
            children: [
              Expanded(
                child: AppText(
                  title,
                  style: (titleColor != null)
                      ? Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: titleColor)
                      : Theme.of(context).textTheme.subtitle2,
                  isSelectable: true,
                ),
              ),
              if (showTrailingIcon)
                AppIconButton(
                  icon: Icons.keyboard_arrow_right,
                  iconSize: 20,
                  removeTagertExtraPadding: false,
                  onPressed: onTap,
                )
              else
                trailingWidget!
            ],
          ),
          if (subtitle != null) subtitle!
        ],
      ),
    );
  }
}

class AppSortItem extends StatelessWidget {
  final String? title;
  final bool? orderByAsc;
  final VoidCallback? onTapAsc;
  final VoidCallback? onTapDesc;

  const AppSortItem({
    required this.title,
    Key? key,
    this.orderByAsc,
    this.onTapAsc,
    this.onTapDesc,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppSortItem(context);
  }

  Widget _buildAppSortItem(BuildContext context) {
    return ListTile(
        title: AppText(
          title,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Transform.rotate(
                angle: -math.pi,
                child: CircularSelectableIconButton(
                    icon: Icons.sort,
                    iconSize: 26,
                    circleRadius: 32,
                    selected: orderByAsc == true,
                    onPressed: onTapAsc),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: AppSpacing.m)),
            CircularSelectableIconButton(
              icon: Icons.sort,
              selected: orderByAsc == false,
              onPressed: onTapDesc,
            ),
          ],
        ));
  }
}

class NavigationPillWidget extends StatelessWidget {
  const NavigationPillWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Wrap(
            children: <Widget>[
              Container(
                width: 50,
                margin: const EdgeInsets.only(
                    top: AppSpacing.ms, bottom: AppSpacing.ms),
                height: AppSpacing.xss,
                decoration: BoxDecoration(
                  color: LightAppColors.bottomSheetBackground,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TextColoredChipWidget extends StatelessWidget {
  final String? text;
  final Color? chipColor;

  const TextColoredChipWidget({
    required this.text,
    required this.chipColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xsss,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.xs)),
        color: chipColor,
      ),
      child: AppText(
        text,
        style: Theme.of(context)
            .textTheme
            .overline!
            .copyWith(color: LightAppColors.light),
      ),
    );
  }
}

class AppToolTip extends StatelessWidget {
  final String? toolTipText;
  final Widget child;

  const AppToolTip({required this.toolTipText, required this.child});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTipText!,
      child: child,
    );
  }
}

/// Choice Chip with Badge
/// @required Add ChipsCountMeta object as meta of item object
class AppChipsChoiceItemCountBadge<T> extends StatelessWidget {
  final AppChipModel<T> item;
  final AppChipStyle choiceStyle;
  final AppChipStyle choiceActiveStyle;
  final Function(bool selected)? onSelect;
  final bool selected;
  final bool isWrapped;

  const AppChipsChoiceItemCountBadge({
    required this.item,
    required this.choiceStyle,
    required this.choiceActiveStyle,
    required this.onSelect,
    required this.selected,
    this.isWrapped = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppChipStyle _style = selected ? choiceActiveStyle : choiceStyle;

    final bool _isDark = _style.brightness == Brightness.dark;

    final Color? _textColor = _isDark ? const Color(0xFFFFFFFF) : _style.color;

    final Color _borderColor = _isDark
        ? const Color(0x00000000)
        : _textColor!.withOpacity(_style.borderOpacity ?? .2);

    final Color? _checkmarkColor =
        _isDark ? _textColor : choiceActiveStyle.color;

    final Color? _backgroundColor =
        _isDark ? choiceStyle.color : const Color(0x00000000);

    final Color? _selectedBackgroundColor =
        _isDark ? choiceActiveStyle.color : const Color(0x00000000);

    final ChipsCountMeta _statusCountData = item.meta;

    return Padding(
      padding: _style.margin != null || isWrapped
          ? const EdgeInsets.all(0)
          : const EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          FilterChip(
            label: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s),
              child: AppText(
                item.label,
                style: _style.labelStyle?.copyWith(color: _textColor) ??
                    TextStyle(color: _textColor),
              ),
            ),
            shape: _style.borderShape as OutlinedBorder? ??
                StadiumBorder(side: BorderSide(color: _borderColor)),
            clipBehavior: _style.clipBehavior ?? Clip.none,
            elevation: _style.elevation,
            pressElevation: _style.pressElevation,
            shadowColor: choiceStyle.color,
            selectedShadowColor: choiceActiveStyle.color,
            backgroundColor: _backgroundColor,
            selectedColor: _selectedBackgroundColor,
            checkmarkColor: _checkmarkColor,
            showCheckmark: _style.showCheckmark == true,
            selected: selected,
            onSelected: item.disabled == false ? onSelect : null,
          ),
          _displayStatusCount(context, _statusCountData),
        ],
      ),
    );
  }

  Widget _displayStatusCount(
      BuildContext context, ChipsCountMeta statusCountData) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: AppSpacing.xl,
          width: AppSpacing.xl,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusCountData.color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 1.0), //(x,y)
                  blurRadius: 3.0,
                )
              ]),
          child: Center(
            child: AppText(
              "${statusCountData.count! > 99 ? "99+" : statusCountData.count}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

/// Colored Choice Chip
/// @required [Color] of chip's selection color as meta of item object.
/// un selected color not implemented (can be done if needed)
class AppChipsChoiceColoredItem<T> extends StatelessWidget {
  final AppChipModel<T> item;
  final AppChipStyle choiceStyle;
  final AppChipStyle choiceActiveStyle;
  final Function(bool selected)? onSelect;
  final bool selected;
  final bool isWrapped;

  const AppChipsChoiceColoredItem({
    required this.item,
    required this.choiceStyle,
    required this.choiceActiveStyle,
    required this.onSelect,
    required this.selected,
    this.isWrapped = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppChipStyle _style = selected ? choiceActiveStyle : choiceStyle;

    final bool _isDark = _style.brightness == Brightness.dark;

    final Color? _textColor = _isDark ? const Color(0xFFFFFFFF) : _style.color;

    final Color _borderColor = _isDark
        ? const Color(0x00000000)
        : _textColor!.withOpacity(_style.borderOpacity ?? .2);

    final Color? _checkmarkColor =
        _isDark ? _textColor : choiceActiveStyle.color;

    final Color? _backgroundColor =
        _isDark ? choiceStyle.color : const Color(0x00000000);

    final Color? _selectionColor = item.meta;

    return Padding(
      padding: _style.margin != null || isWrapped
          ? const EdgeInsets.all(0)
          : const EdgeInsets.all(5),
      child: FilterChip(
        label: AppText(
          item.label,
          style: _style.labelStyle?.copyWith(color: _textColor) ??
              TextStyle(color: _textColor),
        ),
        shape: _style.borderShape as OutlinedBorder? ??
            StadiumBorder(side: BorderSide(color: _borderColor)),
        clipBehavior: _style.clipBehavior ?? Clip.none,
        elevation: _style.elevation,
        pressElevation: _style.pressElevation,
        shadowColor: choiceStyle.color,
        selectedShadowColor: choiceActiveStyle.color,
        backgroundColor: _backgroundColor,
        selectedColor: _selectionColor,
        checkmarkColor: _checkmarkColor,
        showCheckmark: _style.showCheckmark == true,
        selected: selected,
        onSelected: item.disabled == false ? onSelect : null,
      ),
    );
  }
}

/// App Choice Chips
class AppChoiceChips extends StatefulWidget {
  final List<String> chipName;

  AppChoiceChips({required this.chipName});
  @override
  _AppChoiceChipsState createState() => _AppChoiceChipsState();
}

class _AppChoiceChipsState extends State<AppChoiceChips> {
  String _isSelected = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.chipName.forEach((item) {
      choices.add(Container(
        padding: EdgeInsets.only(right: 20.0),
        child: ChoiceChip(
          label: Text(item),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 0.4),
            borderRadius: BorderRadius.circular(12.0),
          ),
          labelStyle: TextStyle(color: Colors.black),
          selectedColor: Colors.pink[200],
          backgroundColor: Colors.white,
          selected: _isSelected == item,
          tooltip: item,
          onSelected: (selected) {
            setState(() {
              _isSelected = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: _buildChoiceList(),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.black, thickness: 1.0);
  }
}
