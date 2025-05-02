import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки уведомлений')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Получать уведомления'),
              value: true, // Здесь можно подключить состояние
              onChanged: (value) {
                // Логика изменения состояния уведомлений
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Уведомления о задачах'),
              value: true, // Здесь можно подключить состояние
              onChanged: (value) {
                // Логика изменения состояния уведомлений о задачах
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Уведомления о событиях'),
              value: false, // Здесь можно подключить состояние
              onChanged: (value) {
                // Логика изменения состояния уведомлений о событиях
              },
            ),
          ],
        ),
      ),
    );
  }
}
