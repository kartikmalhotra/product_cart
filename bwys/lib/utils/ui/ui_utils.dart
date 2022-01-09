import 'dart:async';

import 'package:bwys/config/application.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/config/themes/light_theme.dart';
import 'package:bwys/shared/models/broadcasts_model.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:bwys/utils/services/app_localization.dart';
import 'package:bwys/widget/widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class AppSizedBoxSpacing extends StatelessWidget {
  final double heightSpacing;
  final double widthSpacing;

  const AppSizedBoxSpacing(
      {this.heightSpacing = AppSpacing.xxl, this.widthSpacing = 0.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightSpacing,
      width: widthSpacing,
    );
  }
}

class AppInputLabelText extends StatelessWidget {
  final String? labelText;
  final double leftSpacing;
  final bool isErrorLabel;
  final bool isRequired;

  const AppInputLabelText({
    required this.labelText,
    Key? key,
    this.leftSpacing = 10.0,
    this.isErrorLabel = false,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAppInputLabelText(context);
  }

  Widget _buildAppInputLabelText(BuildContext context) {
    if (isRequired) {
      return Padding(
        padding: EdgeInsets.only(left: leftSpacing),
        child: AppRichText(
          TextSpan(
            children: [
              TextSpan(
                text: "$labelText: ",
                style: (!isErrorLabel)
                    ? Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w500)
                    : Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: LightAppColors.errorBackground),
              ),
              TextSpan(
                text: '*',
                style: (!isErrorLabel)
                    ? Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: LightAppColors.errorBackground)
                    : Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: LightAppColors.errorBackground),
              )
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: leftSpacing),
        child: AppText(
          labelText,
          style: (!isErrorLabel)
              ? Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w500)
              : Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: LightAppColors.errorBackground),
        ),
      );
    }
  }
}

class AppInputMultiline extends StatelessWidget {
  final String? placeholderText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final BoxDecoration? boxDecoration;
  final VoidCallback? onEditingComplete;
  final int? maxLength;

  const AppInputMultiline({
    required this.placeholderText,
    required this.controller,
    Key? key,
    this.textInputType,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.boxDecoration,
    this.onEditingComplete,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAppInputMultiline(context);
  }

  Widget _buildAppInputMultiline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: AppScreenConfig.screenHeight * 0.2,
          decoration:
              boxDecoration ?? _getInputFormDecoration(context, errorText),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  key: key ?? UniqueKey(),
                  maxLines: 10,
                  maxLength: maxLength,
                  maxLengthEnforcement: maxLength != null && maxLength! > 0
                      ? MaxLengthEnforcement.enforced
                      : MaxLengthEnforcement.none,
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: textInputType,
                  enabled: enabled,
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  onChanged: onChanged,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: placeholderText,
                    counterText: "",
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          AppInputLabelText(
            labelText: errorText,
            isErrorLabel: true,
          ),
      ],
    );
  }

  BoxDecoration _getInputFormDecoration(
      BuildContext context, String? errorText) {
    return BoxDecoration(
      border: Border.all(
        color: LightAppColors.errorBackground,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}

class AppTopBar extends StatelessWidget {
  final String? appBarTitle;
  final bool showBackButton;
  final bool closeIconForBackButton;
  final List<Widget>? actionWidgets;
  final VoidCallback? onBackPressed;
  final double appBarWidth;

  ///
  /// [closeIconForBackButton] property will work only if [showBackButton]
  /// is true.
  ///
  const AppTopBar({
    required this.appBarTitle,
    this.showBackButton = true,
    this.closeIconForBackButton = false,
    this.actionWidgets,
    this.onBackPressed,
    this.appBarWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppTopBar(context);
  }

  Widget _buildAppTopBar(BuildContext context) {
    return Container(
      width: appBarWidth,
      height:
          AppScreenConfig.getStatusBarHeight()! + AppSpacing.topAppBarHeight,
      padding: EdgeInsets.only(
          top: AppScreenConfig.getStatusBarHeight()! - AppSpacing.xs / 2),
      child: Row(
        children: <Widget>[
          if (showBackButton)
            if (closeIconForBackButton)
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
              )
            else
              BackButton(
                color: Colors.white,
                onPressed: onBackPressed ?? null,
              ),
          if (showBackButton)
            Expanded(child: _getAppTopBarTitle(context))
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _getAppTopBarTitle(context),
              ),
            ),
          if (actionWidgets != null) Row(children: actionWidgets!),
        ],
      ),
    );
  }

  Widget _getAppTopBarTitle(BuildContext context) {
    return AppToolTip(
      toolTipText: appBarTitle,
      child: Text(
        appBarTitle!,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),
      ),
    );
  }
}

class AppBodyContainer extends StatelessWidget {
  final Widget topAppBar;
  final Widget bodyWidget;
  final bool isBottomNavBarVisible;
  final double paddingLRTB;
  final double topAppBarHeight;

  const AppBodyContainer({
    required this.topAppBar,
    required this.bodyWidget,
    this.isBottomNavBarVisible = false,
    this.paddingLRTB = AppSpacing.s,
    this.topAppBarHeight = AppSpacing.topAppBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
              paddingLRTB,
              topAppBarHeight == 0
                  ? 0
                  : topAppBarHeight +
                      AppScreenConfig.statusbarHeight +
                      paddingLRTB,
              paddingLRTB,
              (isBottomNavBarVisible)
                  ? AppSpacing.bottomNavBarHeight + paddingLRTB
                  : paddingLRTB),
          child: bodyWidget,
        ),
        topAppBar,
      ],
    );
  }
}

/// This class is used to make the horizontal scrollable tabs.
/// Will be horizontal scrollable only if we have the number of tabs does not fit in the mobile screen
/// Used in Search Module, Install CM module etc
typedef IntCallBack = Function(int?);

class AppTabs extends StatelessWidget {
  final List<Tab> tabs;
  final TabController? tabBarController;
  final Color? tabBarColor;
  final IntCallBack? onTabChange;

  const AppTabs({
    required this.tabs,
    this.tabBarController,
    this.tabBarColor,
    this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppTabs(context);
  }

  Widget _buildAppTabs(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(30.0),
      child: Align(
        alignment:
            tabBarColor == null ? Alignment.centerLeft : Alignment.topLeft,
        child: Container(
          width: double.infinity,
          child: Material(
            color: tabBarColor ?? Colors.transparent,
            child: TabBar(
              controller: tabBarController,
              isScrollable: true,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorPadding:
                  const EdgeInsets.only(bottom: 12.0, right: 25.0, left: 25.0),
              indicatorWeight: 4.0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: (Theme.of(context).brightness == Brightness.light)
                  ? Theme.of(context).textTheme.bodyText1!.color
                  : LightAppColors.primaryTextColor,
              unselectedLabelColor:
                  (Theme.of(context).brightness == Brightness.light)
                      ? Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.5)
                      : Theme.of(context).textTheme.bodyText1!.color,
              tabs: tabs,
              onTap: (int index) {
                onTabChange!(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// This class is used to make the horizontal scrollable button styled tabs.
/// Will be horizontal scrollable only if we have the number of tabs does not fit in the mobile screen
/// Used in Search Module, Location Preferences module etc
class AppTabsButton extends StatelessWidget {
  final List<String?> tabs;
  final TabController? tabBarController;

  const AppTabsButton({
    required this.tabs,
    this.tabBarController,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppTabsButton(context);
  }

  Widget _buildAppTabsButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.s),
      height: AppSpacing.xxxxl,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TabBar(
          controller: tabBarController,
          isScrollable: true,
          indicatorColor: LightAppColors.bannerColorLight,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: (Theme.of(context).brightness == Brightness.light)
                  ? LightAppColors.bannerColorLight
                  : Colors.white),
          indicatorWeight: 0,
          labelPadding:
              const EdgeInsets.only(left: AppSpacing.xs, right: AppSpacing.xs),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: (Theme.of(context).brightness == Brightness.light)
              ? Colors.white
              : LightAppColors.primaryButtonTextColor,
          unselectedLabelColor: (Theme.of(context).brightness ==
                  Brightness.light)
              ? Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5)
              : Theme.of(context).textTheme.bodyText1!.color,
          tabs: <Tab>[
            for (var item in tabs)
              Tab(
                child: Container(
                  height: AppSpacing.xxxxl,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color!
                                      .withOpacity(0.5)
                                  : LightAppColors.bannerColorLight,
                          width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: AppSpacing.ms, right: AppSpacing.ms),
                      child: AppText(
                        item,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// This class is used to make the divider with [OR] text in between of the divider
class AppOrDivider extends StatelessWidget {
  final double circularContentPadding;
  final TextStyle? textStyle;

  const AppOrDivider({
    this.circularContentPadding = AppSpacing.xs,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider()),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerTheme.color!),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(circularContentPadding),
              child: AppText(
                AppLocalizations.of(context)!.translate('or'),
                style: textStyle ?? Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class AppAutoComplete extends StatelessWidget {
  final String? placeholderText;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final Widget Function(BuildContext, String?) itemBuilder;
  final FutureOr<Iterable<String>> Function(String) suggestionsCallback;
  final String? errorText;
  final bool showClearIcon;
  final VoidCallback? onSuffixIconPressed;

  const AppAutoComplete({
    required this.placeholderText,
    required this.controller,
    required this.itemBuilder,
    required this.suggestionsCallback,
    Key? key,
    this.errorText,
    this.textInputType,
    this.onSuffixIconPressed,
    this.showClearIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppAutoComplete(context);
  }

  Widget _buildAppAutoComplete(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 51.0,
          child: TypeAheadFormField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: _getInputDecoration(context),
            ),
            hideSuggestionsOnKeyboardHide: false,
            debounceDuration:
                const Duration(milliseconds: AppAnimationDuration.medium),
            suggestionsBoxDecoration: _getSuggestionBoxDecoration(context),
            errorBuilder: (context, error) => Container(height: 0),
            suggestionsCallback: suggestionsCallback,
            itemBuilder: itemBuilder,
            keepSuggestionsOnLoading: false,
            onSuggestionSelected: (dynamic suggestion) =>
                controller!.text = suggestion,
            loadingBuilder: _getLoadingBuilder,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: AppInputLabelText(
              labelText: errorText,
              isErrorLabel: true,
            ),
          )
      ],
    );
  }

  SuggestionsBoxDecoration _getSuggestionBoxDecoration(BuildContext context) {
    return SuggestionsBoxDecoration(
      constraints: BoxConstraints(
        maxHeight: AppScreenConfig.getScreenHeight()! * 0.5,
      ),
      color: Theme.of(context).cardTheme.color,
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    return InputDecoration(
      suffixIcon: (showClearIcon && controller!.text.isNotEmpty)
          ? AppIconButton(icon: Icons.close, onPressed: onSuffixIconPressed)
          : null,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: LightAppColors.errorBackground,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.ms),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: LightAppColors.errorBackground,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.ms),
      ),
      hintText: placeholderText,
      hintStyle: Theme.of(context)
          .textTheme
          .bodyText1!
          .copyWith(color: LightAppColors.errorBackground),
    );
  }

  Widget _getLoadingBuilder(BuildContext context) {
    /// Check if there is not any text in TextEditing Controller then do not show the loading builder
    if (controller!.text.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          AppCircularProgressLoader(),
        ],
      ),
    );
  }
}

// AutoComplete for MAC Search screen for dynamic type of suggestion object
class SearchAutoComplete<T> extends StatelessWidget {
  final String? placeholderText;
  final TextEditingController? controller;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback;
  final String? errorText;
  final bool showClearIcon;
  final VoidCallback? onSuffixIconPressed;
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  final SuggestionsBoxController? suggestionsController;
  final bool hideNoItemsFoundWidget;

  const SearchAutoComplete({
    required this.placeholderText,
    required this.controller,
    required this.itemBuilder,
    required this.suggestionsCallback,
    Key? key,

    /// if ${onSuggestionSelected} is null then suggestion will be set by itself
    /// but if a callback is provided the it's responsibility
    /// to set selection lies in hands for the callback
    this.hideNoItemsFoundWidget = false,
    this.onSuggestionSelected,
    this.errorText,
    this.onSuffixIconPressed,
    this.showClearIcon = false,
    this.suggestionsController,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSearchAutoComplete(context);
  }

  Widget _buildSearchAutoComplete(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            decoration: _getInputDecoration(context),
          ),
          hideSuggestionsOnKeyboardHide: false,
          hideOnEmpty: hideNoItemsFoundWidget,
          debounceDuration:
              const Duration(milliseconds: AppAnimationDuration.xmedium),
          suggestionsBoxDecoration: _getSuggestionBoxDecoration(context),
          suggestionsCallback: suggestionsCallback,
          errorBuilder: (context, error) => Container(height: 0),
          itemBuilder: itemBuilder,
          keepSuggestionsOnLoading: false,
          suggestionsBoxController: suggestionsController,
          onSuggestionSelected: (dynamic suggestion) {
            if (onSuggestionSelected != null) {
              onSuggestionSelected!(suggestion);
            } else {
              controller!.text = suggestion.toString();
            }
          },
          loadingBuilder: _getLoadingBuilder,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: AppInputLabelText(
              labelText: errorText,
              isErrorLabel: true,
            ),
          )
      ],
    );
  }

  SuggestionsBoxDecoration _getSuggestionBoxDecoration(BuildContext context) {
    return SuggestionsBoxDecoration(
      constraints: BoxConstraints(
        maxHeight: AppScreenConfig.getScreenHeight()! * 0.5,
      ),
      color: Theme.of(context).cardTheme.color,
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    return InputDecoration(
      suffixIcon: (showClearIcon && controller!.text.isNotEmpty)
          ? AppIconButton(icon: Icons.close, onPressed: onSuffixIconPressed)
          : null,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.ms),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.ms),
      ),
      hintText: placeholderText,
    );
  }

  Widget _getLoadingBuilder(BuildContext context) {
    /// Check if there is not any text in TextEditing Controller then do not show the loading builder
    if (controller!.text.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          AppCircularProgressLoader(),
        ],
      ),
    );
  }
}

class AppExpandable extends StatelessWidget {
  final String? headerText;
  final Widget? headerTextWidget;
  final Widget? severityIcon;
  final Widget expandedWidget;
  final bool? isInitialExpanded;
  final bool addLabel;
  final double expandedContentPadding;
  final Color? colorExpandable;
  final Color? colorExpandableContentBg;
  final bool? isForSummary;
  final IconData? secondaryActionIcon;
  final VoidCallback? onSecondaryActionTap;
  final IconData? leadingIcon;
  final IntCallBack? onLeadingIconSelection;
  final int? index;
  final Color? leadingIconColor;
  final Color? squareBoxColor;

  /// true when we want to control the state of expandable like in case of birth
  /// certificate pdf generation
  final bool isControlled;

  const AppExpandable({
    required this.expandedWidget,
    Key? key,
    this.headerText,
    this.colorExpandable,
    this.colorExpandableContentBg,
    this.severityIcon,
    this.isForSummary,
    this.isInitialExpanded = false,
    this.addLabel = false,
    this.expandedContentPadding = AppSpacing.s,
    this.secondaryActionIcon,
    this.onSecondaryActionTap,
    this.isControlled = false,
    this.headerTextWidget,
    this.leadingIcon,
    this.onLeadingIconSelection,
    this.index,
    this.leadingIconColor,
    this.squareBoxColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppExpandable(context);
  }

  Widget _buildAppExpandable(BuildContext context) {
    if (!isControlled) {
      return ExpandableNotifier(
        initialExpanded: isInitialExpanded,
        child: _buildExpandablePanel(context),
      );
    } else {
      return ExpandableNotifier(
        controller: ExpandableController(initialExpanded: isInitialExpanded),
        child: _buildExpandablePanel(context),
      );
    }
  }

  ScrollOnExpand _buildExpandablePanel(BuildContext context) {
    return ScrollOnExpand(
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          tapHeaderToExpand: true,
          hasIcon: false,
        ),
        collapsed: Container(),
        header: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                    leadingIcon != null ? AppSpacing.xs : AppSpacing.l,
                    AppSpacing.xs,
                    AppSpacing.l,
                    AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (leadingIcon != null)
                      AppIconButton(
                        icon: leadingIcon,
                        removeTagertExtraPadding: true,
                        onPressed: () {
                          onLeadingIconSelection!(index);
                        },
                        constraints: const BoxConstraints(),
                        iconSize: 25.0,
                        iconColor: leadingIconColor,
                      ),
                    if (addLabel) ...[
                      Icon(
                        Icons.label,
                        size: 20.0,
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.l),
                      ),
                    ],
                    if (headerText != null && headerText != '')
                      if (isForSummary ?? false)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: leadingIcon != null ? AppSpacing.m : 0),
                            child: AppText(
                              headerText,
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        color: colorExpandable == null
                                            ? Theme.of(context).primaryColor
                                            : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: leadingIcon != null ? AppSpacing.m : 0),
                            child: AppText(
                              headerText,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                    if (headerText == null || headerText == '')
                      headerTextWidget!,
                    const AppSizedBoxSpacing(
                      widthSpacing: AppSpacing.xs,
                    ),
                    if (squareBoxColor != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m),
                        child: Container(
                          height: 24.0,
                          width: 24.0,
                          color: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: squareBoxColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0))),
                              child: Container()),
                        ),
                      ),
                    if (secondaryActionIcon != null)
                      CircularIconRaisedButton(
                        onPressed: onSecondaryActionTap,
                        icon: secondaryActionIcon,
                        circleRadius: 25.0,
                        iconSize: 16.0,
                      ),
                    if (secondaryActionIcon != null)
                      const AppSizedBoxSpacing(
                        widthSpacing: AppSpacing.m,
                      ),
                    Builder(
                      builder: (context) {
                        if (colorExpandable == null) {
                          return CircularIconRaisedButton(
                            onPressed: () =>
                                ExpandableController.of(context)!.toggle(),
                            icon: ExpandableController.of(context)!.expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            circleRadius: 25.0,
                            iconSize: 20.0,
                          );
                        } else {
                          return CircularIconRaisedButton(
                            onPressed: () =>
                                ExpandableController.of(context)!.toggle(),
                            icon: ExpandableController.of(context)!.expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            circleRadius: 25.0,
                            fillColor: Colors.black12,
                            iconSize: 20.0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (severityIcon != null) _showSeverityIcon(),
            ],
          ),
        ),
        expanded: Container(
          width: double.infinity,
          transform: Matrix4.translationValues(0.0, -2.0, 0.0),
          child: _showExpandedContent(),
        ),
      ),
    );
  }

  Widget _showSeverityIcon() {
    return Positioned(
      top: 0,
      right: 5.0,
      child: severityIcon!,
    );
  }

  Widget _showExpandedContent() {
    return Card(
      color: colorExpandableContentBg,
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6.0),
          bottomRight: Radius.circular(6.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(expandedContentPadding),
        child: expandedWidget,
      ),
    );
  }
}

typedef DoubleCallback = Function(double);

class AppSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color? activeColor;
  final Color? inactiveColor;
  final int? divisions;
  final bool isLabelVisible;
  final String? label;
  final bool? autoFocus;
  final bool? focusNode;
  final DoubleCallback onChanged;
  final DoubleCallback? onChangedStart;
  final DoubleCallback? onChangedEnd;

  const AppSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.isLabelVisible,
    required this.onChanged,
    this.onChangedStart,
    this.onChangedEnd,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.divisions,
    this.autoFocus,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppSlider(context);
  }

  Widget _buildAppSlider(BuildContext context) {
    return Slider(
      value: value,
      min: min,
      max: max,
      activeColor: activeColor ?? Colors.blue,
      inactiveColor: inactiveColor ?? Colors.black45,
      divisions: divisions ?? 20,
      onChanged: (value) => onChanged(value),
      onChangeStart: (value) =>
          onChangedStart == null ? null : onChangedStart!(value),
      onChangeEnd: (value) =>
          onChangedEnd == null ? null : onChangedEnd!(value),
    );
  }
}

class BroadcastsExpandable extends StatelessWidget {
  final String? headerText;
  final Widget? severityIcon;
  final List<Broadcast>? broadcasts;
  final bool isInitialExpanded;
  final double expandedContentPadding;
  final VoidCallback? onTapClose;
  final Function(String? link)? onTapLink;

  const BroadcastsExpandable({
    required this.headerText,
    required this.broadcasts,
    Key? key,
    this.severityIcon,
    this.isInitialExpanded = false,
    this.expandedContentPadding = AppSpacing.s,
    this.onTapClose,
    this.onTapLink,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBroadcastsExpandable(context);
  }

  Widget _buildBroadcastsExpandable(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: isInitialExpanded,
      child: ScrollOnExpand(
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            tapHeaderToExpand: true,
            hasIcon: false,
          ),
          collapsed: Container(),
          header: Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            margin: const EdgeInsets.all(0.0),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 5.0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: onTapClose,
                      child: Icon(
                        Icons.close,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppScreenConfig.screenHeight * 0.09,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.s,
                        AppSpacing.s, AppSpacing.xss, AppSpacing.xs),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppText(headerText,
                                style: Theme.of(context).textTheme.bodyText1!),
                            Builder(
                              builder: (context) {
                                return !ExpandableController.of(context)!
                                        .expanded
                                    ? AppText(
                                        AppLocalizations.of(context)!
                                            .translate('tap_on_view'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!)
                                    : Container();
                              },
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          expanded: Container(
            transform: Matrix4.translationValues(0.0, -2.0, 0.0),
            child: _showExpandedContent(context),
          ),
        ),
      ),
    );
  }

  Widget _showExpandedContent(BuildContext context) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6.0),
          bottomRight: Radius.circular(6.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(expandedContentPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 0.0,
            maxHeight: AppScreenConfig.getScreenHeight()! * 0.5,
          ),
          child: ShowExpandedContent(
            onTapLink: onTapLink,
          ),
        ),
      ),
    );
  }
}

/// Show Expanded Content
class ShowExpandedContent extends StatefulWidget {
  final Function(String? link)? onTapLink;

  const ShowExpandedContent({
    required this.onTapLink,
    Key? key,
  }) : super(key: key);

  @override
  ShowExpandedContentState createState() => ShowExpandedContentState();
}

class ShowExpandedContentState extends State<ShowExpandedContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _getExpandedViewContent(context),
        ),
      ),
    );
  }

  List<Widget> _getExpandedViewContent(BuildContext context) {
    List<Widget> _widgets = [];

    for (int i = 0; i < Application.broadcasts!.length; i++) {
      _widgets.add(
        _getBroadCastItem(context, Application.broadcasts![i]),
      );

      if (i != Application.broadcasts!.length - 1) {
        _widgets.add(
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.xss, bottom: AppSpacing.s),
            child: Divider(
              thickness: 2,
            ),
          ),
        );
      }
    }

    return _widgets;
  }

  Widget _getBroadCastItem(BuildContext context, Broadcast broadcast) {
    return Html(
      data: broadcast.message,
      onLinkTap: (String? url, _, __, ___) => widget.onTapLink!(url),
      style: {
        "html": Style.fromTextStyle(
          Theme.of(context).textTheme.bodyText2!,
        ),
      },
    );
  }

  void onTapLinks(String url) {
    widget.onTapLink!(url);
  }
}

class AppTitleItems extends StatelessWidget {
  final String? title;
  final VoidCallback onPressed;
  final String? subTitle;
  final severityIcon;

  const AppTitleItems({
    required this.title,
    required this.onPressed,
    this.subTitle,
    this.severityIcon,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAppTitleItems(context);
  }

  Widget _buildAppTitleItems(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: AppSpacing.l,
                  top: AppSpacing.xs,
                  bottom: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      if (subTitle?.isNotEmpty ?? false) ...[
                        const AppSizedBoxSpacing(
                          heightSpacing: AppSpacing.xss,
                        ),
                        AppText(
                          subTitle,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ]
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.m),
                    child: CircularIconRaisedButton(
                      onPressed: onPressed,
                      icon: Icons.keyboard_arrow_right,
                      circleRadius: 25.0,
                      iconSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (severityIcon != null)
            Positioned(top: 7.0, right: 10.0, child: severityIcon),
        ],
      ),
    );
  }
}

// Scroll behaviour to remove over scroll glow effects from list
class NoOverScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class AppShowError extends StatelessWidget {
  final RestAPIErrorModel? error;
  final bool isTryAgain;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  const AppShowError({
    required this.error,
    this.isTryAgain = true,
    this.textAlign = TextAlign.center,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    String? _message = AppLocalizations.of(context)!.translate(error!.code);
    if (_message == null) {}

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        AppText(
          _message ?? error!.message,
          textAlign: textAlign,
          style: textStyle ?? Theme.of(context).textTheme.bodyText2,
        ),
        const AppSizedBoxSpacing(heightSpacing: AppSpacing.l),
        if (isTryAgain)
          AppText(
            AppLocalizations.of(context)!.translate('err_try_again'),
            textAlign: textAlign,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textStyle?.color ??
                      Theme.of(context).textTheme.bodyText1!.color,
                ),
          ),
      ],
    );
  }
}

class AppFilterChipsListTile extends StatelessWidget {
  final String? title;
  final bool selected;
  final Function(bool selected)? onSelect;
  final Widget? trailing;
  final bool enabled;

  const AppFilterChipsListTile({
    required this.title,
    required this.selected,
    required this.onSelect,
    this.trailing,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      enabled: enabled,
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: Icon(
        Icons.check,
        size: (selected && enabled) ? 20.0 : 18.0,
        color: (selected && enabled)
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
      ),
      trailing: (trailing != null) ? trailing : null,
      title: AppText(title, style: Theme.of(context).textTheme.bodyText2),
      onTap: () => onSelect!(!selected),
    );
  }
}

/// This class is used to display the chips with images i.e square image with
/// label
class AppFilterChipsImageTile extends StatelessWidget {
  final String? title;
  final bool selected;
  final Function(bool selected)? onSelect;
  final String imagePath;
  final bool enabled;
  final bool isLocalImage;
  final Widget? onImageContent;
  final double chipHeight;
  final double chipWidth;
  final double imageHeight;
  final double imageWidth;

  const AppFilterChipsImageTile({
    required this.title,
    required this.selected,
    required this.onSelect,
    required this.imagePath,
    this.enabled = true,
    this.isLocalImage = false,
    this.onImageContent,
    this.chipHeight = 90.0,
    this.chipWidth = 80.0,
    this.imageHeight = 50.0,
    this.imageWidth = 50.0,
  }) : assert(imageHeight <= chipHeight && imageWidth <= chipWidth);

  @override
  Widget build(BuildContext context) {
    return _buildFilterChipsImageTile(context);
  }

  Widget _buildFilterChipsImageTile(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(6.0))),
      child: InkWell(
        onTap: enabled ? () => onSelect!(!selected) : null,
        child: AppToolTip(
          toolTipText: AppLocalizations.of(context)!.translate(title),
          child: SizedBox(
            height: chipHeight,
            width: chipWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: enabled ? 1.0 : 0.3,
                      child: Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0)),
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Theme.of(context).primaryColor
                                    : Colors.red
                                : Colors.transparent,
                            width: 2.0,
                          ),
                          image: DecorationImage(
                            image: (isLocalImage
                                    ? AssetImage(imagePath)
                                    : NetworkImage(imagePath))
                                as ImageProvider<Object>,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (onImageContent != null) onImageContent!
                  ],
                ),
                const AppSizedBoxSpacing(heightSpacing: AppSpacing.xss),
                Opacity(
                  opacity: enabled ? 1.0 : 0.3,
                  child: AppText(
                    title,
                    style: selected
                        ? Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Theme.of(context).primaryColor)
                        : Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppMaterialBanner extends StatelessWidget {
  final Key? key;
  final Widget? leading;
  final Widget bannerContent;
  final List<Widget> bannerActions;

  const AppMaterialBanner({
    required this.bannerContent,
    this.key,
    this.leading,
    this.bannerActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      key: key ?? UniqueKey(),
      leading: leading,
      content: bannerContent,
      actions: bannerActions.isNotEmpty ? bannerActions : [Container()],
      padding: (bannerActions.length > 1)
          ? const EdgeInsetsDirectional.only(
              start: 16.0, top: 24.0, end: 16.0, bottom: 4.0)
          : const EdgeInsetsDirectional.only(
              start: 16.0, top: 12.0, bottom: 12.0),
    );
  }
}

class AppCheckboxListTile extends StatelessWidget {
  final Key? key;
  final String? title;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final Widget? secondary;

  const AppCheckboxListTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.key,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.all(0),
      child: CheckboxListTile(
        key: key ?? UniqueKey(),
        title: AppText(title, style: Theme.of(context).textTheme.bodyText2),
        value: value,
        secondary: secondary ?? Container(height: 0.0, width: 0.0),
        activeColor: Theme.of(context).primaryColor,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: onChanged,
      ),
    );
  }
}

class AppDropDown<T> extends StatelessWidget {
  final Key? key;
  final String? hintText;
  final String? errorText;
  final T? value;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;
  final Color? textAndBorderColor;
  final Color? dropDownButtonBGForLight;
  final bool isExpanded;
  final num dropDownHeight;

  const AppDropDown({
    required this.hintText,
    required this.onChanged,
    required this.items,
    this.value,
    this.errorText,
    this.textAndBorderColor,
    this.dropDownButtonBGForLight,
    this.key,
    this.isExpanded = true,
    this.dropDownHeight = 51.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: dropDownHeight as double?,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: DropdownButton<T>(
              key: key ?? UniqueKey(),
              isExpanded: isExpanded,
              underline: Container(),
              hint: AppText(
                hintText,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              value: value,
              onChanged: onChanged,
              items: items,
            ),
          ),
        ),
        if (errorText != null)
          AppInputLabelText(
            labelText: errorText,
            isErrorLabel: true,
          ),
      ],
    );
  }
}

class CommonUtils {
  static NumberFormat? _compactNumberFromat;

  /// Common Method to show the Snack Bar(Tost Message) in the application.
  /// [showAboveBottomNav] - this boolean if true displays snackbars in case
  /// there is a bottom navigation in the screen which hides the snackbar in
  /// normal conditions
  static void appShowSnackBar(BuildContext context, String? message,
      {SnackBarAction? snackBarAction,
      Duration snackBarDuration = const Duration(seconds: 4),
      bool showAboveBottomNav = false}) {
    Widget content;

    if (showAboveBottomNav) {
      content = Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxxl),
        child: AppText(message),
      );
    } else {
      content = AppText(message);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        action: snackBarAction,
        duration: snackBarDuration,
        behavior: showAboveBottomNav ? SnackBarBehavior.floating : null,
      ),
    );
  }

  /// Common Method to show the Snack Bar(RestAPIErrorModel) in the application
  static void appShowErrorSnackBar(
      BuildContext context, RestAPIErrorModel error,
      {bool showAboveBottomNav = false}) {
    String? errorTranslation =
        AppLocalizations.of(context)!.translate(error.code);
    if (errorTranslation == null) {}
    appShowSnackBar(
      context,
      errorTranslation != null
          ? error.loginAttemptsRemaining != null
              ? "$errorTranslation $error.loginAttemptsRemaining"
              : errorTranslation
          : error.message,
      showAboveBottomNav: showAboveBottomNav,
    );
  }

  static NumberFormat? compactNumberFormatter() {
    if (_compactNumberFromat == null) {
      _compactNumberFromat = NumberFormat.compact();
    }

    return _compactNumberFromat;
  }
}

ThemeData getDatePickerTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: LightAppColors.primary,
      surface: LightAppColors.primary,
    ),
  );
}

/// Common [Text] widget for this app.
/// NOTE: if any parameter is not available, it can be added by checking
/// [Text] class
class AppText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final bool isSelectable;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final GestureTapCallback? onTap;

  const AppText(
    this.text, {
    Key? key,
    this.style,
    this.isSelectable = false,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAppText(context);
  }

  Widget _buildAppText(BuildContext context) {
    if (!isSelectable) {
      return Text(
        text!,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
    } else {
      return SelectableText(
        text!,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        onTap: onTap,
      );
    }
  }
}

/// Common [RichText] widget for this app.
/// NOTE: if any parameter is not available, it can be added by checking
/// [RichText] class
class AppRichText extends StatelessWidget {
  final InlineSpan textSpan;

  const AppRichText(
    this.textSpan, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAppText(context);
  }

  Widget _buildAppText(BuildContext context) {
    return RichText(text: textSpan);
  }
}

class AppPhotoHero extends StatelessWidget {
  const AppPhotoHero({
    required this.photo,
    required this.id,
    required this.onTap,
    required this.width,
    required this.height,
  });

  final String photo;
  final int id;
  final VoidCallback onTap;
  final double width;
  final double height;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Hero(
        tag: id,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(photo, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
