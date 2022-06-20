import 'package:flutter/widgets.dart';

class ExtraInfoBoxConstraints<T> extends BoxConstraints {
  ExtraInfoBoxConstraints(
    this.extra,
    BoxConstraints constraints,
  ) : super(
          minWidth: constraints.minWidth,
          minHeight: constraints.minHeight,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        );

  //滑动方向
  final T extra;

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ExtraInfoBoxConstraints &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.minHeight == minHeight &&
        other.maxHeight == maxHeight &&
        other.extra == extra;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return hashValues(minWidth, maxWidth, minHeight, maxHeight, extra);
  }
}
