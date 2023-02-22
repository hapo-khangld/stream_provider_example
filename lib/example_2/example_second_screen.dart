import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../example_3/cat_screen.dart';

final streamProvider = StreamProvider.autoDispose<int>(
  (ref) => Stream.periodic(
      const Duration(seconds: 2), ((computationCount) => computationCount)),
);

class ExampleSecondScreen extends ConsumerWidget {
  const ExampleSecondScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isNextScreen = false;
    final streamData = ref.watch(streamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Provider'),
      ),
      body: streamData.when(
        data: (data) {
          if (data == 5) {
            isNextScreen = true;
          }
          return Center(
            child: Text(
              data.toString(),
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
          );
        },
        error: (error, __) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: isNextScreen
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        },
        child: const Icon(Icons.navigate_next),
      )
          : null,
    );
  }
}
