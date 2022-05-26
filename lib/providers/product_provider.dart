import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../utils/localDB_repo.dart';
import '../utils/logfile.dart';

class ProductProvider with ChangeNotifier{

  List<Product> _productList = [];

  List<Product> get productList => _productList;

  Future<void> cacheProductList() async{
    _productList = await getProductList();
  }

  Future<List<Product>> getProductList() async{
    late List<Product> productList;
    LogFile().logEntry("Fetching Product List from Product Provider.");
    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query("PRODUCT");
        productList =  queryResult.map((e) => Product.fromMap(e)).toList();

      LogFile().logEntry("Product List fetched from Product Provider. Product List Length: ${productList.length}");

    } on Exception catch (e, s) {
      handleException("Error while fetching Product List $e", e, s);
      productList = [];
    }
      return productList;
  }

  Future <Product> getProductById(int id) async{
    late Product product;

    LogFile().logEntry("Fetching Product ID: $id from Product Provider in getProductByID");

    try {
      final List<Map<String, Object?>> queryResult = await LocalDBRepo().db.query('Product', where: "id = ?", whereArgs: [id]);
      product =  queryResult.map((e) => Product.fromMap(e)).toList()[0];

      LogFile().logEntry("Fetched Product ID: $id from Product Provider in getProductByID");
    } on Exception catch (e, s) {
      handleException("Error while fetching Product $e", e, s);
    }
    return product;
  }

  Future<int> saveProduct(Product product) async {
    return product.id == 0? createProduct(product) : updateProduct(product);
  }

  Future<int> createProduct(Product product) async{
    int result = 0;
    LogFile().logEntry("Creating Product in Product Provider");

    try {
      result = await LocalDBRepo().db.insert('PRODUCT', product.toMap());

      LogFile().logEntry("Created Product with id: $result in Product Provider");
      await cacheProductList();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while creating Product $e", e, s);
    }
    return result;
  }

  Future<void> deleteProduct(int id) async {
    LogFile().logEntry("Deleting Product of ID: $id in Product Provider");

    try {
      await LocalDBRepo().db.delete(
        'PRODUCT',
        where: "id = ?",
        whereArgs: [id],
      );
      await cacheProductList();
      notifyListeners();
    } on Exception catch (e, s) {
      handleException("Error while deleting Product Id: $id $e", e, s);
    }

    LogFile().logEntry("Deleted Product of ID: $id in Product Provider");
  }

  Future<int> updateProduct(Product product) async{
    int result = 0;
    LogFile().logEntry("Updating Product of ID: ${product.id} in Product Provider");

    try {
      result = await LocalDBRepo().db.update("PRODUCT", product.toMap(), where: "id = ?", whereArgs:[product.id]);
    } on Exception catch (e, s) {
      handleException("Error while updating Product Id: ${product.id} $e", e, s);
    }
    await cacheProductList();
    notifyListeners();

    LogFile().logEntry("Updated Product of ID: ${product.id} in Product Provider");
    return result;
  }


  void handleException(String message, Exception exception, StackTrace st) {
    LogFile().logEntry("Error $message $exception $st");
  }

  void reset() {
    // customer = null;
  }

  Future<void> testProduct(ProductProvider productProvider) async {

    Product product = Product(name: "Mineral Water", unit: "Litres",);
    int id =await productProvider.createProduct(product);
    LogFile().logEntry("Created Id: $id");
    // product = Product(id: 2, name: "Mineral Water", unit: "Litres",);
    product= await productProvider.getProductById(id);

    product.name = "Updated Min Wat";

    await productProvider.updateProduct(product);

    // Future<List<Product>> productList =  [];
    List<Product> productList = await productProvider.getProductList();



    await productProvider.deleteProduct(id);


    LogFile().logEntry("e2biwfjpdml;2wqefdgqwedfgqwerfdg2ewrtfgew2rgte21ergt43214t566yujhgtfedascgfbty");

  }

}