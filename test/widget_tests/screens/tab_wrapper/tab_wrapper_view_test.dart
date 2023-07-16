import 'package:flutter_test/flutter_test.dart';
import '../../components/widget_under_test.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("Widget test: Tab wrapper", () {
    setUp(() {});

    testWidgets("Tab wrapper is mounted on screen", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
    });
  });
}
