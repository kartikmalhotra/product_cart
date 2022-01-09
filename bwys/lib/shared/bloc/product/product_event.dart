part of 'product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetHomeScreenData extends ProductEvent {
  final int page;

  const GetHomeScreenData({this.page = 0});

  @override
  List<Object> get props => [page];
}

class AddProductData extends ProductEvent {
  final Map<String, dynamic> productData;

  const AddProductData({required this.productData});

  @override
  List<Object> get props => [productData];
}
