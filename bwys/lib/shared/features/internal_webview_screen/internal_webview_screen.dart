// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class InternalWebViewScreen extends StatelessWidget {
//   final String? screenTitle;
//   final String loadUrl;

//   const InternalWebViewScreen(
//       {required this.loadUrl, required this.screenTitle});

//   @override
//   Widget build(BuildContext context) {
//     return _buildWebPageScreen(context);
//   }

//   Widget _buildWebPageScreen(BuildContext context) {
//     return Scaffold(
//       body: AppBodyContainer(
//         topAppBar: AppTopBar(
//           appBarTitle: screenTitle,
//           showBackButton: true,
// //          actionWidgets: null,
//         ),
//         bodyWidget: InternalWebView(
//           loadUrl: loadUrl,
//         ),
//         isBottomNavBarVisible: false,
//         paddingLRTB: 0,
//       ),
//     );
//   }
// }

// class InternalWebView extends StatefulWidget {
//   final String loadUrl;

//   const InternalWebView({required this.loadUrl});

//   @override
//   State<StatefulWidget> createState() => InternalWebViewScreenState();
// }

// class InternalWebViewScreenState extends State<InternalWebView> {
//   late WebViewController _webViewController;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       onWebViewCreated: (WebViewController webViewController) async {
//         _webViewController = webViewController;
//         _loadUrl();
//       },
//       javascriptMode: JavascriptMode.unrestricted,
//       onPageFinished: (String url) {
//         Application.logService!.log('Page finished loading:');
// //        _isWebViewPageLoaded = true;
// //        _webViewController.evaluateJavascript(_evaluateJavascriptexpression);
//       },
//     );
//   }

//   void _loadUrl() async {
//     await _webViewController.loadUrl(widget.loadUrl);
//   }
// }
