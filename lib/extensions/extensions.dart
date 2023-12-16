import 'dart:ui';

extension Aspect on Size {
  bool get aspectIsLandscape => aspectRatio >= 1;
  bool get aspectIsPortrait => !aspectIsLandscape;
}