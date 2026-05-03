import 'package:flutter_test/flutter_test.dart';
import 'package:pawmap_vietnam/main.dart';

void main() {
  testWidgets('PawMap app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PawMapApp());
    expect(find.text('PawMap Vietnam'), findsAny);
  });
}
