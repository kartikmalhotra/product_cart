part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  /// Passing class fields in a list to the Equatable super class
  const AuthenticationEvent([List props = const []]) : super();
}
