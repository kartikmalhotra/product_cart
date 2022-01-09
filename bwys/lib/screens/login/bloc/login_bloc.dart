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
    } else if (event is SignUpButtonPressed) {
      yield* _mapSignUpButtonPressedToState(event);
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

  Stream<LoginState> _mapSignUpButtonPressedToState(
      SignUpButtonPressed event) async* {
    Map<String, dynamic> cred = event.cred;

    var response = await Application.firebaseService!
        .createNewUser(cred["email"], cred["password"]);

    if (response is UserCredential) {
      yield SignUpResult(signUp: true, signUpError: "");
    }
    yield SignUpResult(signUp: false, signUpError: response);
  }
}
