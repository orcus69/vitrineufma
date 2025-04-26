import 'package:flutter/material.dart';

class MaterialTags extends StatelessWidget {
  final List<String> tags;

  const MaterialTags({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags.map((tag) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            tag,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
