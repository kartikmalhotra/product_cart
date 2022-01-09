import 'package:bwys/widget/chips_choice/model/model.dart';
import 'package:flutter/material.dart';

/// Callback when the value changed
typedef void C2Changed<T>(T value);

/// Builder for custom choice item
typedef Widget CustomChipBuilder<T>(AppChipModel<T?> item);

/// Easy way to provide a single or multiple choice chips.
class AppChipsChoice<T> extends StatefulWidget {
  /// List of choice item
  final List<AppChipModel<T>>? choiceItems;

  /// Choice unselected item style
  final AppChipStyle? choiceStyle;

  /// Choice selected item style
  final AppChipStyle? choiceActiveStyle;

  /// Builder for custom choice item
  final CustomChipBuilder? choiceBuilder;

  /// Container padding
  final EdgeInsetsGeometry? padding;

  /// how much space to place between children in a run in the main axis.
  final double spacing;

  ///  how much space to place between the runs themselves in the cross axis.
  final double runSpacing;

  final T? _value;
  final List<T>? _values;
  final C2Changed<T>? _onChangedSingle;
  final C2Changed<List<T>>? _onChangedMultiple;
  final bool _isMultiChoice;

  /// Costructor for single choice
  const AppChipsChoice.single({
    required T value,
    required C2Changed<T> onChanged,
    required this.choiceItems,
    Key? key,
    this.choiceStyle,
    this.choiceActiveStyle,
    this.choiceBuilder,
    this.padding,
    this.spacing = 10.0,
    this.runSpacing = 0,
  })  : _isMultiChoice = false,
        _value = value,
        _values = null,
        _onChangedMultiple = null,
        _onChangedSingle = onChanged,
        super(key: key);

  /// Constructor for multiple choice
  AppChipsChoice.multiple({
    required List<T>? value,
    required C2Changed<List<T>> onChanged,
    required List<AppChipModel<T>> this.choiceItems,
    Key? key,
    this.choiceStyle,
    this.choiceActiveStyle,
    this.choiceBuilder,
    this.padding,
    this.spacing = 10.0,
    this.runSpacing = 0,
  })  : _isMultiChoice = true,
        _value = null,
        _values = value ?? [],
        _onChangedSingle = null,
        _onChangedMultiple = onChanged,
        super(key: key);

  @override
  ChipsChoiceState<T> createState() => ChipsChoiceState<T>();
}

/// Chips Choice State
class ChipsChoiceState<T> extends State<AppChipsChoice<T>> {
  /// get default theme
  ThemeData get theme => Theme.of(context);

  /// default style for unselected choice item
  AppChipStyle get defaultChoiceStyle => AppChipStyle(
      margin: const EdgeInsets.all(0), color: theme.unselectedWidgetColor);

  /// default style for selected choice item
  AppChipStyle get defaultActiveChoiceStyle =>
      AppChipStyle(margin: const EdgeInsets.all(0), color: theme.primaryColor);

  /// choice items
  List<AppChipModel<T>>? choiceItems;

  /// choice loader error
  Error? error;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    /// initial load choice items
    _loadChoiceItems();

    super.initState();
  }

  @override
  void didUpdateWidget(AppChipsChoice<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.choiceItems != widget.choiceItems) {
      _loadChoiceItems();
    }
  }

  /// load the choice items
  void _loadChoiceItems() async {
    try {
      setState(() {
        error = null;
        choiceItems = widget.choiceItems;
      });
    } catch (e) {
      setState(() => error = e as Error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return choiceItems != null && choiceItems!.isNotEmpty
        ? _displayChipsList()
        : Container();
  }

  /// the wrapped list
  Widget _displayChipsList() {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: widget.spacing, // gap between adjacent chips
        runSpacing: widget.runSpacing, // gap between lines
        clipBehavior: Clip.hardEdge,
        children: choiceChips,
      ),
    );
  }

  /// generate the choice chips
  List<Widget> get choiceChips {
    return List<Widget?>.generate(choiceItems!.length, choiceChipsGenerator)
        .where((e) => e != null)
        .toList()
        .cast<Widget>();
  }

  /// choice chips generator
  Widget? choiceChipsGenerator(int i) {
    final AppChipModel<T> item = choiceItems![i].copyWith(
      selected: widget._isMultiChoice
          ? widget._values!.contains(choiceItems![i].value)
          : widget._value == choiceItems![i].value,
      select: _select(choiceItems![i].value),
    );
    return item.hidden == false
        ? widget.choiceBuilder?.call(item) ??
            AppChip(
              data: item,
              style: defaultChoiceStyle
                  .merge(widget.choiceStyle)
                  .merge(item.style),
              activeStyle: defaultActiveChoiceStyle
                  .merge(widget.choiceStyle)
                  .merge(item.style)
                  .merge(widget.choiceActiveStyle)
                  .merge(item.activeStyle),
            )
        : null;
  }

  /// return the selection function
  Function(bool selected) _select(T value) {
    return (bool selected) {
      if (widget._isMultiChoice) {
        List<T> values = List.from(widget._values ?? []);
        if (selected) {
          values.add(value);
        } else {
          values.remove(value);
        }
        widget._onChangedMultiple?.call(values);
      } else {
        widget._onChangedSingle?.call(value);
      }
    };
  }
}

/// Default App Chip widget
class AppChip<T> extends StatelessWidget {
  /// choice item data
  final AppChipModel<T> data;

  /// unselected choice style
  final AppChipStyle style;

  /// selected choice style
  final AppChipStyle activeStyle;

  /// label widget
  final Widget? label;

  /// default constructor
  const AppChip({
    required this.data,
    required this.style,
    required this.activeStyle,
    Key? key,
    this.label,
  }) : super(key: key);

  /// get shape border
  static ShapeBorder getShapeBorder({
    required Color color,
    double? width,
    BorderRadiusGeometry? radius,
    BorderStyle? style,
  }) {
    return radius == null
        ? StadiumBorder(
            side: BorderSide(
                color: color,
                width: width ?? 1.0,
                style: style ?? BorderStyle.solid))
        : RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
                color: color,
                width: width ?? 1.0,
                style: style ?? BorderStyle.solid),
          );
  }

  /// default border opacity
  static const double defaultBorderOpacity = .2;

  @override
  Widget build(BuildContext context) {
    final AppChipStyle effectiveStyle = data.selected ? activeStyle : style;
    final bool isDark = effectiveStyle.brightness == Brightness.dark;
    final Color? textColor =
        isDark ? const Color(0xFFFFFFFF) : effectiveStyle.color;
    final Color borderColor = isDark
        ? const Color(0x00000000)
        : textColor!
            .withOpacity(effectiveStyle.borderOpacity ?? defaultBorderOpacity);
    final Color? checkmarkColor = isDark ? textColor : activeStyle.color;
    final Color? backgroundColor =
        isDark ? style.color : const Color(0x00000000);
    final Color? selectedBackgroundColor =
        isDark ? activeStyle.color : const Color(0x00000000);

    return Padding(
      padding: effectiveStyle.margin!,
      child: RawChip(
        padding: effectiveStyle.padding,
        label: label ?? Text(data.label!),
        labelStyle:
            TextStyle(color: textColor).merge(effectiveStyle.labelStyle),
        labelPadding: effectiveStyle.labelPadding,
        tooltip: data.tooltip,
        shape: effectiveStyle.borderShape as OutlinedBorder? ??
            getShapeBorder(
              color: effectiveStyle.borderColor ?? borderColor,
              width: effectiveStyle.borderWidth,
              radius: effectiveStyle.borderRadius,
              style: effectiveStyle.borderStyle,
            ) as OutlinedBorder?,
        clipBehavior: effectiveStyle.clipBehavior ?? Clip.none,
        elevation: effectiveStyle.elevation ?? 0,
        pressElevation: effectiveStyle.pressElevation ?? 0,
        shadowColor: style.color,
        selectedShadowColor: activeStyle.color,
        backgroundColor: backgroundColor,
        selectedColor: selectedBackgroundColor,
        checkmarkColor: checkmarkColor,
        showCheckmark: effectiveStyle.showCheckmark,
        materialTapTargetSize: effectiveStyle.materialTapTargetSize,
        disabledColor:
            effectiveStyle.disabledColor ?? Colors.blueGrey.withOpacity(.1),
        isEnabled: data.disabled != true,
        selected: data.selected,
        onSelected: (_selected) => data.select!(_selected),
      ),
    );
  }
}
