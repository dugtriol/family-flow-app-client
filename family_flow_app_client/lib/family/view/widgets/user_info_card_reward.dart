import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String userName;
  final int userPoints;

  const UserInfoCard({
    required this.userName,
    required this.userPoints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Привет, $userName!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ваши очки: $userPoints',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            const Icon(
              Icons.account_circle,
              size: 48,
              color: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }
}
