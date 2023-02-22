import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_provider_example/example_2/example_second_screen.dart';

const names = [
  'khang1',
  'khang2',
  'khang3',
  'khang4',
  'khang5',
  'khang6',
  'khang7',
  'khang8',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (i) => i + 1),
);

// final tickerProvider2 = StreamProvider.autoDispose(
//       (ref) {
//     final controller = StreamController<int>();
//     ref.onDispose(controller.close);
//     Stream.periodic(const Duration(seconds: 1), (i) => i + 1)
//         .takeWhile((count) => count <= names.length)
//         .listen(controller.add);
//     return controller.stream;
//   },
// );

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(0, count),
      ),
);

final namesProvider2 = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map((count) {
    final endIndex = count.clamp(0, names.length);
    return names.getRange(0, endIndex);
  }),
);

class FirstExampleScreen extends ConsumerStatefulWidget {
  const FirstExampleScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FirstExampleScreenState();
}

class _FirstExampleScreenState extends ConsumerState<FirstExampleScreen> {
  bool isNamesDisplayed = false;

  @override
  Widget build(BuildContext context) {
    final names = ref.watch(namesProvider2);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Provider'),
      ),
      body: names.when(
        data: (names) {
          if (names.length == 8) {
            isNamesDisplayed = true;
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  names.elementAt(index),
                ),
              );
            },
            itemCount: names.length,
          );
        },
        error: (_, __) => const Text('Failed'),
        loading: () => const CircularProgressIndicator(),
      ),
      floatingActionButton: isNamesDisplayed
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExampleSecondScreen(),
                  ),
                );
              },
              child: const Icon(Icons.navigate_next),
            )
          : null,
    );
  }
}
