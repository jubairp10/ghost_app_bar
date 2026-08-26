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

  testWidgets('titles default to theme colors, not hardcoded white',
      (tester) async {
    final theme = ThemeData(brightness: Brightness.light);
    await tester.pumpWidget(MaterialApp(
      theme: theme,
      home: Scaffold(
        body: GhostAppBarScaffold.children(
          title: 'Chats',
          children: const [SizedBox(height: 10)],
        ),
      ),
    ));

    final large = tester.widget<Text>(find.text('Chats').first);
    expect(large.style!.color, theme.colorScheme.onSurface);
    expect(large.style!.color, isNot(Colors.white));
  });

  testWidgets('explicit scrimColor and styles still win over the theme',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: GhostAppBarScaffold.children(
          title: 'Chats',
          scrimColor: const Color(0xFF06140A),
          largeTitleStyle: const TextStyle(color: Colors.white),
          children: const [SizedBox(height: 10)],
        ),
      ),
    ));

    final large = tester.widget<Text>(find.text('Chats').first);
    expect(large.style!.color, Colors.white);
  });

  testWidgets('custom largeTitle and compactTitle widgets replace the text',
      (tester) async {
    await tester.pumpWidget(wrap(
      GhostAppBarScaffold.children(
        largeTitle: const Icon(Icons.dashboard),
        compactTitle: const Icon(Icons.dashboard_outlined),
        children: const [SizedBox(height: 10)],
      ),
    ));

    expect(find.byIcon(Icons.dashboard), findsOneWidget);
    expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
  });

  testWidgets('a title string still fills in a missing custom widget',
      (tester) async {
    await tester.pumpWidget(wrap(
      GhostAppBarScaffold.children(
        title: 'Settings',
        largeTitle: const Icon(Icons.settings),
        children: const [SizedBox(height: 10)],
      ),
    ));

    // Large title is the icon; compact falls back to the title text.
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  test('asserts when neither a title nor both custom widgets are given', () {
    expect(
      () => GhostAppBarScaffold.children(
        largeTitle: const Icon(Icons.abc),
        children: const [],
      ),
      throwsAssertionError,
    );
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
