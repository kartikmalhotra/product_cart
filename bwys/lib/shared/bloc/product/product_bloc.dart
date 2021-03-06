import 'package:bwys/config/application.dart';
import 'package:bwys/screens/home/repository/repository.dart';
import 'package:bwys/shared/models/product_model.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(HomeInitial());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is AddProductData) {
      yield* _mapAddProductDataToState(event);
    }
  }

  Stream<ProductState> _mapAddProductDataToState(AddProductData event) async* {
    Map<String, dynamic> _productDetails = event.productData;
    var response = await Application.firebaseService!.addProduct(
        _productDetails["name"],
        _productDetails["description"],
        _productDetails["price"],
        _productDetails["image"] ?? "");
    if (response == "success") {
      yield AddProductMessage(productAdded: true);
    } else {
      yield AddProductMessage(productAdded: false, errorMessage: response);
    }
  }

  void divideDataIntoPages(List<Product> data) {
    List<List<Product>> pages = [];
    int chunkSize = 10;
    for (var i = 0; i < data.length; i += chunkSize) {
      pages.add(
        data.sublist(
            i, i + chunkSize > data.length ? data.length : i + chunkSize),
      );
    }
    productRepository.productListData = pages;
  }
}
