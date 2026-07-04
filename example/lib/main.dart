import 'package:flutter/material.dart';
import 'package:ghost_app_bar/ghost_app_bar.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: GhostAppBarScaffold.children(
          title: 'Chats',
          scrimColor: Colors.white,
          largeTitleStyle: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          compactTitleStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          leading: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, color: Colors.black54),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () {},
            ),
          ],
          children: [
            for (var i = 0; i < 40; i++)
              ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.black12),
                title: Text(
                  'Contact $i',
                  style: const TextStyle(color: Colors.black87),
                ),
                subtitle: Text(
                  'Last message preview…',
                  style: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
