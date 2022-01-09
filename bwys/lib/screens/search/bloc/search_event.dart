part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchProductsEvent extends SearchEvent {
  final String searchString;

  const SearchProductsEvent({
    required this.searchString,
  });

  @override
  List<Object> get props => [searchString];
}
