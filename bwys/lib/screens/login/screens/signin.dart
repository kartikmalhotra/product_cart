import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/login/bloc/login_bloc.dart';
import 'package:bwys/screens/login/repository/repository.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _showBackgroundImage(context),
            _displaySignInForm(context),
          ],
        ),
      ),
    );
  }

  Widget _showBackgroundImage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: CachedNetworkImage(
          fit: BoxFit.fitHeight,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
              color: Colors.black,
            ),
          ),
          imageUrl:
              "https://images.unsplash.com/photo-1639351516356-8ed2dc90b4ed?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80",
        ),
      ),
    );
  }

  Widget _displaySignInForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(repository: LoginRepositoryImpl()),
            child: SignInForm(),
          )
        ],
      ),
    );
  }
}

// Define a custom Form widget.
class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SignInFormState extends State<SignInForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return BlocListener<LoginBloc, LoginState>(
      listener: _loginBlocListener,
      child: _displayFrom(context),
    );
  }

  Widget _displayFrom(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              _email = value;
              return null;
            },
          ),
          AppSizedBoxSpacing(),
          TextFormField(
            style: TextStyle(color: Colors.white),
            obscureText: !_passwordVisible, //This will obscure text dynamically
            decoration: InputDecoration(
              suffix: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),

            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Email or Phone';
              }
              _password = value;
              return null;
            },
          ),
          AppSizedBoxSpacing(),
          AppElevatedButton(
            color: Colors.white,
            minWidth: 400,
            textColor: Colors.black,
            message: "SIGN IN WITH EMAIL",
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<LoginBloc>(context).add(
                  SignInButtonPressed(cred: {
                    "email": _email,
                    "password": _password,
                  }),
                );
              }
            },
          ),
          Text(
            "OR",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
          AppSizedBoxSpacing(heightSpacing: 5),
          AppElevatedButton(
            color: Colors.white,
            minWidth: 400,
            textColor: Colors.black,
            message: "SIGN IN WITH GOOGLE",
            onPressed: () =>
                BlocProvider.of<LoginBloc>(context).add(SignInWithGoogle()),
          ),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
          Center(
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
              child: AppText(
                "Already have an account?  Signup",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          AppSizedBoxSpacing(),
        ],
      ),
    );
  }

  void _loginBlocListener(BuildContext context, state) {
    if (state is SignInResult) {
      if (state.userSignedIn) {
        Navigator.pushReplacementNamed(context, AppRoutes.appScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${state.signInError}")),
        );
      }
    }
  }
}
