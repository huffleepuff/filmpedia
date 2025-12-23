import 'package:flutter_test/flutter_test.dart';
import 'package:filmpedia/main.dart';

void main() {
  testWidgets('App can be built', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Cek apakah app berhasil dibuild
    expect(find.byType(MyApp), findsOneWidget);
  });
}
