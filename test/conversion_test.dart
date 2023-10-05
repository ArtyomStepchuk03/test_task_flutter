import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/pages/main_screen.dart';

void main() {
  test('Values should bu greater then 0', () {
    expect(convert(10, -2), "0");
    expect(convert(-10, -2), "0");
    expect(convert(-10, 2), "0");
  });
  test('Result should have 4 digits after dot', () {
    expect(convert(0, 20), "0.0000");
  });
}