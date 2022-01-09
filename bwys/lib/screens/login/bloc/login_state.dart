part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class SignInResult extends LoginState {
  final bool userSignedIn;
  final String signInError;

  const SignInResult({
    required this.userSignedIn,
    required this.signInError,
  });

  @override
  List<Object> get props => [
        userSignedIn,
        signInError,
      ];
}
