import 'package:flutter/material.dart';

abstract class WidgetView<T, U> extends StatelessWidget {
  final U state;

  T get widget => (state as State).widget as T;

  const WidgetView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}