import 'package:calculated_life/core/providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('scrapper session clears text', () {
    final notifier = ScrapperSessionNotifier();

    notifier.setText('stress dump');
    expect(notifier.text, 'stress dump');

    notifier.clear();
    expect(notifier.text, isEmpty);
  });
}
