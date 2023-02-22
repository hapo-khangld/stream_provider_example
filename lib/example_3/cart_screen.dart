
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cartProvider = StreamProvider<List<String>>((ref) {
  return StreamController<List<String>>().stream;
});


class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartStream = ref.watch(cartProvider);
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

    void _addItem(String item) {
      final controller = ref.read(cartProvider).controller;
      final currentItems = controller.value ?? [];
      controller.add([...currentItems, item]);
      scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text('Added $item to cart')));
    }

    void _removeItem(String item) {
      final controller = ref.read(cartProvider);
      final currentItems = controller.value ?? [];
      final newItems = List<String>.from(currentItems)..remove(item);
      controller.add(newItems);
      scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text('Removed $item from cart')));
    }

    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(title: const Text('Cart')),
      body: StreamBuilder<List<String>>(
        stream: cartStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () => _removeItem(item),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem('Item ${DateTime.now().second}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}