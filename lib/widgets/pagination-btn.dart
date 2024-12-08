import 'package:flutter/material.dart';

class PaginationButton extends StatelessWidget {
  const PaginationButton(
      {required this.function, required this.title, super.key});

  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function;
      },
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(6),
          backgroundColor: Colors.blue),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
