import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class ProductListProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  String categoriaSeleacionada = '';
  bool isLoading = true;
  late ProductModel selectedProduct;

  ProductListProvider() {
    cargarProduct();
  }

  newProduct(String nombre, String? categoria, double precio, int stock,
      String? imagen, int? id) async {
    final newProduct = ProductModel(
      nombre: nombre,
      categoria: categoria,
      precio: precio,
      stock: stock,
      imagen: imagen,
      id: id,
    );
    await DBProvider.db.newProduct(newProduct);
    products.add(newProduct);
    notifyListeners();
  }

  Future<List<ProductModel>> cargarProduct() async {
    isLoading = true;
    notifyListeners();
    final products = await DBProvider.db.getProductAll();
    this.products = [...products];
    isLoading = false;
    notifyListeners();
    return this.products;
  }

  cargarProductByCategory(String categoria) async {
    final products = await DBProvider.db.getProductByType(categoria);
    this.products = [...products];
    categoriaSeleacionada = categoria;
    notifyListeners();
  }

  deleteAll() async {
    await DBProvider.db.deleteProductAll();
    products = [];
    notifyListeners();
  }

  deleteById(int id) async {
    await DBProvider.db.deleteProductById(id as ProductModel);
    cargarProductByCategory(categoriaSeleacionada);
  }
}
