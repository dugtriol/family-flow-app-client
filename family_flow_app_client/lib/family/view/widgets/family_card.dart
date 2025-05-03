import 'package:flutter/material.dart';

class FamilyCard extends StatelessWidget {
  final String familyName;

  const FamilyCard({super.key, required this.familyName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Тень для объёмности
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Закруглённые углы
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.home,
              size: 40,
              color: Colors.deepPurple, // Иконка семьи
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                familyName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
