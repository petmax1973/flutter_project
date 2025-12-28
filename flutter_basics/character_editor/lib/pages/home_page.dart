import 'package:character_editor/components/character_start_editor.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Character Editor'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            CharacterStatEditor(label: "forza", value: 2),
            CharacterStatEditor(label: "resistenza", value: 3),
            CharacterStatEditor(label: "velocità", value: 1),
          ],
        ),
      ),
    );
  }
}
