import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DoubleValueListenableBuilder extends StatelessWidget {
  const DoubleValueListenableBuilder({
    super.key,
    required this.firstValue,
    required this.secondValue,
    this.child,
    required this.builder,
  });

  final ValueListenable firstValue;
  final ValueListenable secondValue;
  final Widget? child;
  final Widget Function(
          BuildContext context, dynamic first, dynamic second, Widget? child)
      builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: firstValue,
      builder: (_, first, __) {
        return ValueListenableBuilder(
          valueListenable: secondValue,
          builder: (context, second, child) {
            return builder(context, first, second, child);
          },
        );
      },
    );
  }
}
