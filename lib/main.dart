import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(transform ?? (e) => e)
          .where(
            (e) => e != null,
          )
          .cast();
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

const url =
    'https://images.unsplash.com/photo-1471879832106-c7ab9e0cee23?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;
    controller = useStreamController<double>(onListen: () {
      controller.sink.add(0.0);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final rotation = snapshot.data ?? 0.0;
            return GestureDetector(
              onTap: () {
                controller.sink.add(rotation + 10);
              },
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(rotation / 360),
                child: Center(
                  child: Image.network(url),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
