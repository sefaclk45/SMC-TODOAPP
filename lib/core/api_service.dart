import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:logger/logger.dart";
import "package:todoapp/core/model/product.dart";

class ApiService {
  String _baseURL = "";
  static ApiService _instance = ApiService._privateConstructor();
  ApiService._privateConstructor() {
    _baseURL = "https://fbgunluk-fb0d9-default-rtdb.firebaseio.com/";
  }
  static ApiService getInstance() {
    if (_instance == null) return ApiService._privateConstructor();
    return _instance;
  }

  Future<List<Products>?> getProducts() async {
    final response = await http.get(Uri.parse("$_baseURL/products.json"));
    final jsonResponse = json.decode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        final productList = ProductList.fromJsonList(jsonResponse);
        return productList.products;
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    return Future.error(jsonResponse);
  }

  Future<String?> addProducts(Products product) async {
    final jsonBody = json.encode(product.toJson());
    final response =
        await http.post(Uri.parse("$_baseURL/products.json"), body: jsonBody);
    final jsonResponse = json.decode(response.body);
    switch (response.statusCode) {
      case HttpStatus.ok:
        return Future.value(jsonResponse['name'].toString());
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    return null;
  }

  Future<void> removeProducts(String key) async {
    final response =
        await http.delete(Uri.parse("$_baseURL/products/$key.json"));
    final jsonResponse = json.decode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return Future.value(true);
      case HttpStatus.unauthorized:
        Logger().e(jsonResponse);
        break;
    }
    return Future.error(jsonResponse);
  }

  Future<bool> editProducts(String id, Products product) async {
    final jsonBody = json.encode(product.toJson());
    final response = await http.put(
      Uri.parse("$_baseURL/products/$id.json"),
      body: jsonBody,
    );
    final jsonResponse = json.decode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        Logger().i("Product updated successfully: $jsonResponse");
        return Future.value(true);
      case HttpStatus.unauthorized:
        Logger().e("Unauthorized request: $jsonResponse");
        break;
      default:
        Logger().e("Error: ${response.statusCode} - ${jsonResponse}");
        break;
    }
    return Future.value(false);
  }
}




// Future<ServiceResult<List<Products>>> getProducts() async {
//     ServiceResult<List<Products>> result;
//     final response = await http.get(Uri.parse("$_baseURL/products.json"));

//     if (response.statusCode == HttpStatus.ok) {
//       final jsonResponse = json.decode(response.body);
//       final productList = ProductList.fromJsonList(jsonResponse);
//       result = ServiceResult(true, data: [], message: "başarili oldu.");
//       // return productList.products
//     } else {
//       result = ServiceResult(false, data: [], message: "başarisiz!");
//     }

//     return result;
//   }
// }

// class ServiceResult<T> {
//   final T? data;

//   final String? message;

//   final bool isSuccess;

//   ServiceResult(this.isSuccess, {required this.data, required this.message});
// }
