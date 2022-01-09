import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/themes/light_theme.dart';
import 'package:bwys/screens/home/screens/home_screen.dart';
import 'package:bwys/screens/profile/screens/profile_screen.dart';
import 'package:bwys/shared/bloc/product/product_bloc.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes/routes.dart';

class BwysApp extends StatelessWidget {
  const BwysApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData['themeData'] as ThemeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteSetting.generateRoute,
    );
  }
}

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightAppColors.cardBackground,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocProvider<ProductBloc>.value(
          value: BlocProvider.of<ProductBloc>(context),
          child: IndexedStack(
            index: _currentIndex,
            children: [
              DisplayHomeScreen(),
              Center(child: AppText("Currently Going live is not available")),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.black),
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
