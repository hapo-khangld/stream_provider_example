import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_provider_example/example_3/produc_model.dart';

import 'cart.dart';
import 'cat_model.dart';

final cartController = StreamController<CartEvent>.broadcast();

final cartProvider = StreamProvider<Cart>((ref) {
  final cart = Cart();

  ref.onDispose(() {
    cartController.close();
  });

  cartController.stream.listen((event) {
    if (event is AddToCartEvent) {
      cart.addProduct(event.product);
    } else if (event is RemoveFromCartEvent) {
      cart.removeProduct(event.productId);
    }
  });

  return Stream.value(cart);
});

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.value?.products.length,
              itemBuilder: (context, index) {
                final product = cart.value?.products[index];
                return ListTile(
                  title: Text(product?.name ?? 'khang'),
                  subtitle: Text('\$${product?.price}'),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  final product =
                      Product(id: 1, name: 'Product 1', price: 9.99);
                  cartController.add(AddToCartEvent(product));
                },
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () {
                  cartController.add(RemoveFromCartEvent(1));
                },
                child: const Text('Remove'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
