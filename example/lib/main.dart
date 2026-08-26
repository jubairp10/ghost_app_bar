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
        // No colors passed to GhostAppBarScaffold — it follows the theme.
        body: GhostAppBarScaffold.children(
          title: 'Chats',
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
                leading: const CircleAvatar(child: Text('C')),
                title: Text('Contact $i'),
                subtitle: const Text('Last message preview…'),
              ),
          ],
        ),
      ),
    );
  }
}
