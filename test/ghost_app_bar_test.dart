import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghost_app_bar/ghost_app_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('shows large title, compact title hidden initially',
      (tester) async {
    await tester.pumpWidget(wrap(
      GhostAppBarScaffold.children(
        title: 'Chats',
        children: [for (var i = 0; i < 50; i++) SizedBox(height: 60, child: Text('Item $i'))],
      ),
    ));

    // Title appears twice (large + compact); compact is at opacity 0.
    expect(find.text('Chats'), findsNWidgets(2));
    final opacity = tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: find.text('Chats').last,
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(opacity.opacity, 0);
  });

  testWidgets('compact title fades in after scrolling past collapseOffset',
      (tester) async {
    await tester.pumpWidget(wrap(
      GhostAppBarScaffold.children(
        title: 'Chats',
        children: [for (var i = 0; i < 50; i++) SizedBox(height: 60, child: Text('Item $i'))],
      ),
    ));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
    await tester.pumpAndSettle();

    final opacity = tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: find.text('Chats').last,
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(opacity.opacity, 1);
  });

  testWidgets('renders leading and actions', (tester) async {
    await tester.pumpWidget(wrap(
      GhostAppBarScaffold.children(
        title: 'T',
        leading: const Icon(Icons.arrow_back),
        actions: const [Icon(Icons.search)],
        children: const [SizedBox(height: 10)],
      ),
    ));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
