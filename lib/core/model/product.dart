class Products {
  String? productName;
  String? day;
  String? imageURL;
  String? key;

  Products({this.productName, this.day, this.imageURL});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    day = json['day'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['day'] = this.day;
    data['imageURL'] = this.imageURL;
    return data;
  }
}

class ProductList {
  List<Products> products = [];

  ProductList.fromJsonList(Map value) {
    value.forEach((key, value) {
      var product = Products.fromJson(value);
      product.key = key;
      products.add(product);
    });
  }
}
