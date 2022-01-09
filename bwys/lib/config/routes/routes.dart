import 'package:bwys/bwys_app.dart';
import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/screens/add_product/add_product.dart';
import 'package:bwys/screens/home/repository/repository.dart';
import 'package:bwys/screens/login/screens/signin.dart';
import 'package:bwys/screens/login/screens/signup.dart';
import 'package:bwys/screens/splash_screen/screen/splash_screen.dart';
import 'package:bwys/shared/bloc/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteSetting {
  static RouteSetting? _routeSetting;
  static ProductBloc? _productBloc;

  RouteSetting._internal();

  static RouteSetting? getInstance() {
    if (_routeSetting == null) {
      _initializeBloc();
      _routeSetting = RouteSetting._internal();
    }
    return _routeSetting;
  }

  static void _initializeBloc() {
    _productBloc = ProductBloc(productRepository: ProductRepositoryImpl());
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.root:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case AppRoutes.appScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProductBloc>.value(
            value: _productBloc!,
            child: AppScreen(),
          ),
        );
      case AppRoutes.addProduct:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ProductBloc>.value(
            value: _productBloc!,
            child: AddProductScreen(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
