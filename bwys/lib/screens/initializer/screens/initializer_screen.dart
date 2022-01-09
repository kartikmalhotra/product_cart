import 'package:bwys/screens/initializer/bloc/initializer_bloc.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitializerScreen extends StatelessWidget {
  const InitializerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "BWYS",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10.0),
              ),
              AppSizedBoxSpacing(heightSpacing: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class InitializerScreenLoader extends StatefulWidget {
  InitializerScreenLoader({Key? key}) : super(key: key);

  @override
  _InitializerScreenLoaderState createState() =>
      _InitializerScreenLoaderState();
}

class _InitializerScreenLoaderState extends State<InitializerScreenLoader> {
  @override
  void initState() {
    super.initState();
    _oneSecongDelay();
  }

  void _oneSecongDelay() async {
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializerBloc, InitializerState>(
      listener: _initializerBlocListener,
    );
  }

  void _initializerBlocListener(BuildContext context, InitializerState state) {}
}
