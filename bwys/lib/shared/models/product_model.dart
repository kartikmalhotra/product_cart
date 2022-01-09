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
    productId = json['id'];
    productName = json['name'];
    productDescription = json['description'];
    productPrice = json['price'];
    imageURl = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.productId;
    data['name'] = this.productName;
    data['description'] = this.productDescription;
    data['price'] = this.productPrice;
    data['imageURl'] = this.imageURl;
    return data;
  }
}
