import 'package:flutter/material.dart';

/// Choice option
class AppChipModel<T> {
  /// Value to return
  final T value;

  /// Represent as primary text
  final String? label;

  /// Tooltip string to be used for the body area (where the label and avatar are) of the chip.
  final String? tooltip;

  /// Whether the choice is disabled or not
  final bool disabled;

  /// Whether the choice is hidden or displayed
  final bool hidden;

  /// This prop is useful for choice builder
  final dynamic meta;

  /// Individual choice unselected item style
  final AppChipStyle? style;

  /// Individual choice selected item style
  final AppChipStyle? activeStyle;

  /// Callback to select choice
  /// autofill by the system
  /// used in choice builder
  final Function(bool selected)? select;

  /// Whether the choice is selected or not
  /// autofill by the system
  /// used in choice builder
  final bool selected;

  /// Default Constructor
  const AppChipModel({
    required this.value,
    required this.label,
    this.tooltip,
    this.disabled = false,
    this.hidden = false,
    this.meta,
    this.style,
    this.activeStyle,
    this.select,
    this.selected = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppChipModel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  /// Helper to create choice items from any list
  static List<AppChipModel<R>> listFrom<R, E>({
    required List<E> source,
    required _C2ChoiceProp<E, R> value,
    required _C2ChoiceProp<E, String?> label,
    _C2ChoiceProp<E, String>? tooltip,
    _C2ChoiceProp<E, bool>? disabled,
    _C2ChoiceProp<E, bool>? hidden,
    _C2ChoiceProp<E, dynamic>? meta,
    _C2ChoiceProp<E, AppChipStyle>? style,
    _C2ChoiceProp<E, AppChipStyle>? activeStyle,
  }) =>
      source
          .asMap()
          .map((index, item) => MapEntry(
              index,
              AppChipModel<R>(
                value: value.call(index, item),
                label: label.call(index, item),
                tooltip: tooltip?.call(index, item),
                disabled: disabled?.call(index, item) ?? false,
                hidden: hidden?.call(index, item) ?? false,
                meta: meta?.call(index, item),
                style: style?.call(index, item),
                activeStyle: activeStyle?.call(index, item),
              )))
          .values
          .toList()
          .cast<AppChipModel<R>>();

  /// Creates a copy of this [AppChipModel] but with
  /// the given fields replaced with the new values.
  AppChipModel<T> copyWith({
    T? value,
    String? label,
    String? tooltip,
    bool? disabled,
    bool? hidden,
    dynamic meta,
    AppChipStyle? style,
    AppChipStyle? activeStyle,
    Function(bool selected)? select,
    bool? selected,
  }) {
    return AppChipModel<T>(
      value: value ?? this.value,
      label: label ?? this.label,
      tooltip: tooltip ?? this.tooltip,
      disabled: disabled ?? this.disabled,
      hidden: hidden ?? this.hidden,
      meta: meta ?? this.meta,
      style: style ?? this.style,
      activeStyle: activeStyle ?? this.activeStyle,
      select: select ?? this.select,
      selected: selected ?? this.selected,
    );
  }

  /// Creates a copy of this [S2Choice] but with
  /// the given fields replaced with the new values.
  AppChipModel<T> merge(AppChipModel<T>? other) {
    // if null return current object
    if (other is AppChipModel && other == null) return this;

    return copyWith(
      value: other!.value,
      label: other.label,
      tooltip: other.tooltip,
      disabled: other.disabled,
      hidden: other.hidden,
      meta: other.meta,
      style: other.style,
      activeStyle: other.activeStyle,
      select: other.select,
      selected: other.selected,
    );
  }
}

/// Builder for option prop
typedef R _C2ChoiceProp<T, R>(int index, T item);

/// Choice item style configuration
class AppChipStyle {
  /// Item color
  final Color? color;

  /// choice item margin
  final EdgeInsetsGeometry? margin;

  /// The padding between the contents of the chip and the outside [shape].
  ///
  /// Defaults to 4 logical pixels on all sides.
  final EdgeInsetsGeometry? padding;

  /// Chips elevation
  final double? elevation;

  /// Longpress chips elevation
  final double? pressElevation;

  /// whether the chips use checkmark or not
  final bool? showCheckmark;

  /// Chip label style
  final TextStyle? labelStyle;

  /// Chip label padding
  final EdgeInsetsGeometry? labelPadding;

  /// Chip brightness
  final Brightness? brightness;

  /// Chip border color
  final Color? borderColor;

  /// Chip border opacity,
  /// only effect when [brightness] is [Brightness.light]
  final double? borderOpacity;

  /// The width of this side of the border, in logical pixels.
  final double? borderWidth;

  /// The radii for each corner.
  final BorderRadiusGeometry? borderRadius;

  /// The style of this side of the border.
  ///
  /// To omit a side, set [style] to [BorderStyle.none].
  /// This skips painting the border, but the border still has a [width].
  final BorderStyle? borderStyle;

  /// Chips shape border
  final ShapeBorder? borderShape;

  /// Chip border color
  final Color? avatarBorderColor;

  /// The width of this side of the border, in logical pixels.
  final double? avatarBorderWidth;

  /// The radii for each corner.
  final BorderRadiusGeometry? avatarBorderRadius;

  /// The style of this side of the border.
  ///
  /// To omit a side, set [style] to [BorderStyle.none].
  /// This skips painting the border, but the border still has a [width].
  final BorderStyle? avatarBorderStyle;

  /// Chips shape border
  final ShapeBorder? avatarBorderShape;

  /// Chips clip behavior
  final Clip? clipBehavior;

  /// Configures the minimum size of the tap target.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Color to be used for the chip's background indicating that it is disabled.
  ///
  /// It defaults to [Colors.black38].
  final Color? disabledColor;

  /// Default Constructor
  const AppChipStyle({
    this.color,
    this.margin,
    this.padding,
    this.elevation,
    this.pressElevation,
    this.showCheckmark,
    this.labelStyle,
    this.labelPadding,
    this.brightness,
    this.borderColor,
    this.borderOpacity,
    this.borderWidth,
    this.borderRadius,
    this.borderStyle,
    this.borderShape,
    this.avatarBorderColor,
    this.avatarBorderWidth,
    this.avatarBorderRadius,
    this.avatarBorderStyle,
    this.avatarBorderShape,
    this.clipBehavior,
    this.materialTapTargetSize,
    this.disabledColor,
  });

  /// Creates a copy of this [AppChipStyle] but with
  /// the given fields replaced with the new values.
  AppChipStyle copyWith({
    Color? color,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    double? pressElevation,
    bool? showCheckmark,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    Brightness? brightness,
    Color? borderColor,
    double? borderOpacity,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    BorderStyle? borderStyle,
    ShapeBorder? borderShape,
    Color? avatarBorderColor,
    double? avatarBorderWidth,
    BorderRadiusGeometry? avatarBorderRadius,
    BorderStyle? avatarBorderStyle,
    ShapeBorder? avatarBorderShape,
    Clip? clipBehavior,
    MaterialTapTargetSize? materialTapTargetSize,
    Color? disabledColor,
  }) {
    return AppChipStyle(
      color: color ?? this.color,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
      pressElevation: pressElevation ?? this.pressElevation,
      showCheckmark: showCheckmark ?? this.showCheckmark,
      labelStyle: labelStyle ?? this.labelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      brightness: brightness ?? this.brightness,
      borderColor: borderColor ?? this.borderColor,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      borderStyle: borderStyle ?? this.borderStyle,
      borderShape: borderShape ?? this.borderShape,
      avatarBorderColor: avatarBorderColor ?? this.avatarBorderColor,
      avatarBorderWidth: avatarBorderWidth ?? this.avatarBorderWidth,
      avatarBorderRadius: avatarBorderRadius ?? this.avatarBorderRadius,
      avatarBorderStyle: avatarBorderStyle ?? this.avatarBorderStyle,
      avatarBorderShape: avatarBorderShape ?? this.avatarBorderShape,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      materialTapTargetSize:
          materialTapTargetSize ?? this.materialTapTargetSize,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  /// Creates a copy of this [AppChipStyle] but with
  /// the given fields replaced with the new values.
  AppChipStyle merge(AppChipStyle? other) {
    // if null return current object
    if (other == null) return this;

    return copyWith(
      color: other.color,
      margin: other.margin,
      padding: other.padding,
      elevation: other.elevation,
      pressElevation: other.pressElevation,
      showCheckmark: other.showCheckmark,
      labelStyle: other.labelStyle,
      labelPadding: other.labelPadding,
      brightness: other.brightness,
      borderColor: other.borderColor,
      borderOpacity: other.borderOpacity,
      borderWidth: other.borderWidth,
      borderRadius: other.borderRadius,
      borderStyle: other.borderStyle,
      borderShape: other.borderShape,
      avatarBorderColor: other.avatarBorderColor,
      avatarBorderWidth: other.avatarBorderWidth,
      avatarBorderRadius: other.avatarBorderRadius,
      avatarBorderStyle: other.avatarBorderStyle,
      avatarBorderShape: other.avatarBorderShape,
      clipBehavior: other.clipBehavior,
      materialTapTargetSize: other.materialTapTargetSize,
      disabledColor: other.disabledColor,
    );
  }
}
