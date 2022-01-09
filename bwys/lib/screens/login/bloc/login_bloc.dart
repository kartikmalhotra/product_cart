import 'package:bloc/bloc.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/screens/login/repository/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is SignInButtonPressed) {
      yield* _mapSignInButtonPressedToState(event);
    } else if (event is SignInWithGoogle) {
      yield* _mapSignInWithGoogleToState(event);
    }
  }

  Stream<LoginState> _mapSignInButtonPressedToState(
      SignInButtonPressed event) async* {
    bool userSignedIn = false;
    var response = await Application.firebaseService!
        .signInWithEmail(event.cred["email"], event.cred["password"]);
    if (response is String) {
      yield SignInResult(
        userSignedIn: userSignedIn,
        signInError: response,
      );
    } else if (response is UserCredential) {
      userSignedIn = true;
      Application.userRepository!.storeUserCredentials({
        "email": response.user!.email!,
        "password": event.cred["password"],
      });
      yield SignInResult(
        userSignedIn: userSignedIn,
        signInError: "",
      );
    }
  }

  Stream<LoginState> _mapSignInWithGoogleToState(
      SignInWithGoogle event) async* {
    var response = await Application.firebaseService!.signInWithGoogle();
    if (response is! Exception) {
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     AppRoutes.appScreen, (Route<dynamic> route) => false);
    }

    // Map<String, dynamic>? checkUser = checkUserValid(event.cred);
  }

 
}
