// import 'dart:async';

// import 'package:bwys/config/screen_config.dart';
// import 'package:bwys/const/themes/light_theme.dart';
// import 'package:bwys/utils/ui/ui_utils.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// This class is the used to show the expandable content in application
// ///
// /// The Expanded content will be loaded dynamically i.e when user expands the List tile then only expanded content will be loaded
// class AppExpandableDynamic extends StatelessWidget {
//   final String? headerText;
//   final Widget? headerTextWidget;
//   final StreamController<bool>? headerTextTapped;
//   final Widget? expandedWidget;
//   final VoidCallback expandablePanelListner;
//   final Widget? severityIcon;
//   final bool isInitialExpanded;
//   final bool addLabel;
//   final double expandedContentPadding;

//   const AppExpandableDynamic({
//     required this.headerText,
//     required this.expandedWidget,
//     required this.expandablePanelListner,
//     Key? key,
//     this.headerTextWidget,
//     this.headerTextTapped,
//     this.severityIcon,
//     this.isInitialExpanded = false,
//     this.addLabel = false,
//     this.expandedContentPadding = AppSpacing.l,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return _buildAppExpandableDynamic(context);
//   }

//   Widget _buildAppExpandableDynamic(BuildContext context) {
//     return _AppExpandable(
//       headerText: headerText,
//       headerTextWidget: headerTextWidget,
//       headerTextTapped: headerTextTapped,
//       expandedWidget: expandedWidget,
//       expandablePanelListner: expandablePanelListner,
//       severityIcon: severityIcon,
//       isInitialExpanded: isInitialExpanded,
//       addLabel: addLabel,
//       expandedContentPadding: expandedContentPadding,
//     );
//   }
// }

// class _AppExpandable extends StatefulWidget {
//   final String? headerText;
//   final Widget? headerTextWidget;
//   final StreamController<bool>? headerTextTapped;
//   final Widget? expandedWidget;
//   final VoidCallback expandablePanelListner;
//   final Widget? severityIcon;
//   final bool isInitialExpanded;
//   final bool addLabel;
//   final double expandedContentPadding;

//   const _AppExpandable({
//     required this.headerText,
//     required this.headerTextWidget,
//     required this.headerTextTapped,
//     required this.expandedWidget,
//     required this.expandablePanelListner,
//     required this.severityIcon,
//     required this.isInitialExpanded,
//     required this.addLabel,
//     required this.expandedContentPadding,
//   });

//   @override
//   State<StatefulWidget> createState() => _AppExpandableState();
// }

// class _AppExpandableState extends State<_AppExpandable> {
//   String? headerText;
//   Widget? headerTextWidget;
//   late StreamSubscription headerTextTapped;
//   Widget? expandedWidget;
//   late VoidCallback expandablePanelListner;
//   Widget? severityIcon;
//   bool? isInitialExpanded;
//   late bool addLabel;
//   late double expandedContentPadding;
//   ExpandableController? controller;

//   @override
//   void initState() {
//     /// subscribe to stream from parent widget to listen for header text tapped
//     headerTextTapped = widget.headerTextTapped!.stream.listen((bool landscape) {
//       controller!.toggle();
//     });
//     headerText = widget.headerText;
//     headerTextWidget = widget.headerTextWidget;
//     expandablePanelListner = widget.expandablePanelListner;
//     severityIcon = widget.severityIcon;
//     isInitialExpanded = widget.isInitialExpanded;
//     addLabel = widget.addLabel;
//     expandedContentPadding = widget.expandedContentPadding;

//     /// initialize the expandable controller
//     controller = ExpandableController();

//     /// Add the listener to the controller
//     controller!.addListener(expandablePanelListner);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     /// stream must be cancelled once widget is ready to be disposed off
//     headerTextTapped.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// initialize the expandedWidget
//     expandedWidget = widget.expandedWidget;

//     /// return the Expandable Panel
//     return _buildExpandablePanel();
//   }

//   Widget _buildExpandablePanel() {
//     return ExpandableNotifier(
//       initialExpanded: isInitialExpanded,
//       child: ScrollOnExpand(
//         child: ExpandablePanel(
//           controller: controller,
//           theme: const ExpandableThemeData(
//             tapHeaderToExpand: true,
//             hasIcon: false,
//           ),
//           header: _getExpandableHeader(),
//           expanded: Container(
//             transform: Matrix4.translationValues(0.0, -2.0, 0.0),
//             child: _showExpandedContent(),
//           ),
//           collapsed: Container(),
//         ),
//       ),
//     );
//   }

//   Widget _getExpandableHeader() {
//     return Container(
//       decoration: _getBoxDecoration(),
//       child: Stack(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.fromLTRB(
//                 AppSpacing.l, AppSpacing.xs, AppSpacing.l, AppSpacing.xs),
//             child: Row(
//               children: <Widget>[
//                 if (addLabel) ...[
//                   Icon(
//                     Icons.label,
//                     color: Theme.of(context).primaryColor,
//                     size: 20.0,
//                   ),
//                   const Padding(
//                     padding: const EdgeInsets.only(left: AppSpacing.l),
//                   )
//                 ],
//                 if (headerText?.isNotEmpty ?? false)
//                   AppText(
//                     headerText,
//                     style: Theme.of(context)
//                         .textTheme
//                         .subtitle2!
//                         .copyWith(color: Theme.of(context).primaryColor),
//                   ),
//                 if (headerText?.isEmpty ?? true && headerTextWidget != null)
//                   headerTextWidget!,
//                 Builder(
//                   builder: (context) {
//                     return CircularIconRaisedButton(
//                       onPressed: () => controller!.toggle(),
//                       icon: controller!.expanded
//                           ? Icons.keyboard_arrow_up
//                           : Icons.keyboard_arrow_down,
//                       circleRadius: 25.0,
//                       iconSize: 20.0,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           if (severityIcon != null) _showSeverityIcon(),
//         ],
//       ),
//     );
//   }

//   BoxDecoration _getBoxDecoration() {
//     return BoxDecoration(
//       borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//       border: Border.all(
//         color: LightAppColors.borderColor,
//       ),
//     );
//   }

//   Widget _showSeverityIcon() {
//     return Positioned(
//       top: 0,
//       right: 5.0,
//       child: severityIcon!,
//     );
//   }

//   Widget _showExpandedContent() {
//     return Card(
//       shape: const RoundedRectangleBorder(
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(6.0),
//           bottomRight: Radius.circular(6.0),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(expandedContentPadding),
//         child: expandedWidget,
//       ),
//     );
//   }
// }

// class AppScrollbarPainter extends StatefulWidget {
//   const AppScrollbarPainter({
//     required this.child,
//     Key? key,
//     this.scrollDirection = Axis.vertical,
//     this.reverse = false,
//     this.padding,
//     this.primary,
//     this.physics,
//     this.controller,
//     this.dragStartBehavior = DragStartBehavior.down,
//     this.scrollbarColor,
//   }) : super(key: key);

//   final Axis scrollDirection;
//   final bool reverse;
//   final EdgeInsets? padding;
//   final bool? primary;
//   final ScrollPhysics? physics;
//   final ScrollController? controller;
//   final Widget child;
//   final DragStartBehavior dragStartBehavior;
//   final Color? scrollbarColor;

//   @override
//   _AppScrollbarPainterState createState() => _AppScrollbarPainterState();
// }

// class _AppScrollbarPainterState extends State<AppScrollbarPainter> {
//   AlwaysVisibleScrollbarPainter? _scrollbarPainter;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     rebuildPainter();
//   }

//   @override
//   void didUpdateWidget(AppScrollbarPainter oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     rebuildPainter();
//   }

//   void rebuildPainter() {
//     final theme = Theme.of(context);
//     _scrollbarPainter = AlwaysVisibleScrollbarPainter(
//       color: widget.scrollbarColor ?? theme.highlightColor.withOpacity(1.0),
//       textDirection: Directionality.of(context),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollbarPainter?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: CustomPaint(
//         foregroundPainter: _scrollbarPainter,
//         child: RepaintBoundary(
//           child: ListView(
//             scrollDirection: widget.scrollDirection,
//             reverse: widget.reverse,
//             padding: widget.padding,
//             primary: widget.primary,
//             physics: widget.physics,
//             controller: widget.controller,
//             dragStartBehavior: widget.dragStartBehavior,
//             children: <Widget>[
//               Builder(
//                 builder: (context) {
//                   if (Scrollable.of(context)!.position.hasContentDimensions) {
//                     _scrollbarPainter?.scrollable = Scrollable.of(context)!;
//                   }
//                   return widget.child;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AlwaysVisibleScrollbarPainter extends ScrollbarPainter {
//   AlwaysVisibleScrollbarPainter({
//     required Color color,
//     required TextDirection textDirection,
//   }) : super(
//           color: color,
//           textDirection: textDirection,
//           fadeoutOpacityAnimation: const AlwaysStoppedAnimation(1.0),
//         );

//   ScrollableState? _scrollable;

//   ScrollableState? get scrollable => _scrollable;

//   set scrollable(ScrollableState? value) {
//     _scrollable?.position.removeListener(_onScrollChanged);
//     _scrollable = value;
//     _scrollable?.position.addListener(_onScrollChanged);
//     _onScrollChanged();
//   }

//   void _onScrollChanged() {
//     if (scrollable != null) {
//       update(_scrollable!.position, _scrollable!.axisDirection);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
