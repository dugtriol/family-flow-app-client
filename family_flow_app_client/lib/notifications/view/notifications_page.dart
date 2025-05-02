import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications;

  const NotificationsPage({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        backgroundColor: Colors.deepPurple,
      ),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  'Нет уведомлений',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notifications[index]),
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.deepPurple,
                    ),
                  );
                },
              ),
    );
  }
}
