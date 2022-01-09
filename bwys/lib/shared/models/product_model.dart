class ProductList {
  late List<Product> products;

  ProductList({required this.products});

  ProductList.fromJson(Map<String, dynamic> json) {
    products = <Product>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.products.map((v) => v.toJson()).toList();
    return data;
  }
}

class Product {
  int? productId;
  String? productName;
  String? productDescription;
  int? productPrice;
  String? imageURl;

  Product({
    this.productId,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.imageURl,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    imageURl = json['imageURl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['product_price'] = this.productPrice;
    data['imageURl'] = this.imageURl;
    return data;
  }
}
