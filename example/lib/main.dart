import 'package:flutter/material.dart';
import 'package:ghost_app_bar/ghost_app_bar.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        // No colors passed — the bar follows the ambient theme.
        body: GhostAppBarScaffold.children(
          // The expanded header is any widget, not just a string.
          largeTitle: const _Header(),
          // So is the content that fades into the collapsed bar.
          compactTitle: Row(
            children: [
              const Icon(Icons.folder_rounded, size: 20),
              const SizedBox(width: 8),
              Text('Library', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          leading: const CircleAvatar(
            radius: 18,
            child: Icon(Icons.person, size: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(_dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _dark = !_dark),
            ),
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
          children: [
            for (var i = 0; i < 40; i++)
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.article)),
                title: Text('Document $i'),
                subtitle: const Text('Edited 2 days ago'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shows that the expanded header can be any widget — here a heading with a
/// subtitle rather than a single line of text.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Library',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          '40 documents · 2 shared',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
