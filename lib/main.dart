import 'dart:math';

import 'package:flutter/material.dart';
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

enum Action { rotateLeft, rotateRight, moreVisible, lessVisible, reset }

@immutable
class State {
  final double rotationDegree;
  final double alpha;

  const State({
    required this.rotationDegree,
    required this.alpha,
  });
  const State.zero()
      : rotationDegree = 0.0,
        alpha = 1.0;

  State rotateRight() =>
      State(rotationDegree: rotationDegree + 10.0, alpha: alpha);
  State rotateLeft() =>
      State(rotationDegree: rotationDegree - 10.0, alpha: alpha);
  State increaseAlpha() => State(
        rotationDegree: rotationDegree,
        alpha: min(alpha + 0.1, 1.0),
      );
  State decreaseAlpha() => State(
        rotationDegree: rotationDegree,
        alpha: max(alpha - 0.1, 0.0),
      );
  State reset() => const State.zero();
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case Action.reset:
      return oldState.reset();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateLeft);
                },
                child: const Text('Rotate left'),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.rotateRight);
                },
                child: const Text('Rotate right'),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.moreVisible);
                },
                child: const Text('More visible'),
              ),
              TextButton(
                onPressed: () {
                  store.dispatch(Action.lessVisible);
                },
                child: const Text('Less visible'),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotationDegree / 360),
              child: Image.network(url),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          TextButton(
            onPressed: () {
              store.dispatch(Action.reset);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
