import 'package:flutter_template_riverpod/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RiverpodTemplateApp());

    // Verify that the app builds without crashing.
    expect(find.byType(RiverpodTemplateApp), findsOneWidget);
  });
}
