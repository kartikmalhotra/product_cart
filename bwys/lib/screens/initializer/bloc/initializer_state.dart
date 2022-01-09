part of 'initializer_bloc.dart';

abstract class InitializerState extends Equatable {
  const InitializerState();
  
  @override
  List<Object> get props => [];
}

class InitializerInitial extends InitializerState {}
