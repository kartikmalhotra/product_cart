part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SignInButtonPressed extends LoginEvent {
  final Map<String, dynamic> cred;

  const SignInButtonPressed({required this.cred});

  @override
  List<Object> get props => [cred];
}

class SignInWithGoogle extends LoginEvent {
  const SignInWithGoogle();
}
