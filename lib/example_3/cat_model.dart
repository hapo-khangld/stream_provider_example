import 'package:stream_provider_example/example_3/produc_model.dart';

abstract class CartEvent {
  const CartEvent();

  factory CartEvent.addToCart(Product product) = AddToCartEvent;
  factory CartEvent.removeFromCart(int productId) = RemoveFromCartEvent;
}

class AddToCartEvent extends CartEvent {
  final Product product;

  AddToCartEvent(this.product);
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  RemoveFromCartEvent(this.productId);
}
