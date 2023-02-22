import 'package:stream_provider_example/example_3/produc_model.dart';

class Cart {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
  }

  void removeProduct(int productId) {
    _products.removeWhere((product) => product.id == productId);
  }
}
