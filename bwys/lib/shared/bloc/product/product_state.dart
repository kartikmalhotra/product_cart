part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {
  final RestAPIErrorModel? restAPIError;
  final List<List<Product>>? productList;

  const ProductState({
    this.restAPIError,
    this.productList,
  });
}

class HomeInitial extends ProductState {
  const HomeInitial();

  List<Object> get props => [];
}

/// Show Home Loader
class ShowHomeLoader extends ProductState {
  const ShowHomeLoader();

  @override
  List<Object> get props => [];
}

/// Home Data Loaded State
class HomeDataLoadedState extends ProductState {
  final RestAPIErrorModel? restAPIError;
  final List<List<Product>>? products;

  const HomeDataLoadedState({
    this.restAPIError,
    this.products,
  }) : super(
          restAPIError: restAPIError,
          productList: products,
        );

  @override
  List<Object?> get props => [
        restAPIError,
        products,
      ];
}

class AddProductMessage extends ProductState {
  final bool productAdded;
  final String? errorMessage;

  const AddProductMessage({
    this.productAdded = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        productAdded,
        errorMessage,
      ];
}
