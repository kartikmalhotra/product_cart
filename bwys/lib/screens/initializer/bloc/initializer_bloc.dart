import 'package:bloc/bloc.dart';
import 'package:bwys/screens/initializer/repository/repository.dart';
import 'package:equatable/equatable.dart';

part 'initializer_event.dart';
part 'initializer_state.dart';

class InitializerBloc extends Bloc<InitializerEvent, InitializerState> {
  final InitializerScreenRepo repository;

  InitializerBloc({required this.repository}) : super(InitializerInitial());
}
