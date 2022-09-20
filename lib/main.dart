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
    /// caching complex object with useMemoized returns future
    final future = useMemoized(
      () => NetworkAssetBundle(Uri.parse(url))
          .load(url)
          .then(
            (data) => data.buffer.asUint8List(),
          )
          .then(
            (data) => Image.memory(data),
          ),
    );

    /// to consume the future
    final snapshot = useFuture(future);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          snapshot.data,
        ].compactMap().toList(),
      ),
    );
  }
}
