import 'package:bwys/config/application.dart';
import 'package:bwys/constants/app_constants.dart';
import 'package:bwys/constants/path/api_path.dart';
import 'package:bwys/shared/models/product_model.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:bwys/utils/services/rest_api_service.dart';

abstract class ProductRepository {
  /// Getter and Setter for product list data
  List<List<Product>> get productList;
  set productListData(List<List<Product>> productList);
}

class ProductRepositoryImpl extends ProductRepository {
  late List<List<Product>> _productList;

  @override
  List<List<Product>> get productList => _productList;

  @override
  set productListData(List<List<Product>> productList) {
    _productList = productList;
  }

  Future<dynamic> fetchVideoCategoryList() async {
    try {
      final response = Application.restService!.requestCall(
        apiEndPoint: AppRestEndPoints.videoList,
        method: RestAPIRequestMethods.GET,
      );
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }
}
