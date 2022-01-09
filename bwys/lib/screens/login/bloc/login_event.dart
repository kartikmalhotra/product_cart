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

class SignUpButtonPressed extends LoginEvent {
  final Map<String, dynamic> cred;

  const SignUpButtonPressed({required this.cred});

  @override
  List<Object> get props => [cred];
}
