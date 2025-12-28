import 'package:flutter/material.dart';

class CharacterStatEditor extends StatefulWidget {
  final String label;
  final int value;

  const CharacterStatEditor({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  State<CharacterStatEditor> createState() => _CharacterStatEditorState();
}

class _CharacterStatEditorState extends State<CharacterStatEditor> {
  int value = 0;

  void initState() {
    super.initState();
    value = widget.value;
  }

  void incrementValue() {
    setState(() {
      value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      leading: Text(
        value.toString(),
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: incrementValue,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: Icon(Icons.add, size: 16),
      ),
    );
  }
}
