import 'package:flutter/material.dart';
import 'package:wishlist_api/wishlist_api.dart';

class WishlistDetailsDialog extends StatelessWidget {
  const WishlistDetailsDialog({
    super.key,
    required this.item,
    required this.isOwner,
  });

  final WishlistItem item;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              icon: Icons.description,
              label: 'Описание',
              value: item.description,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.link,
              label: 'Ссылка',
              value: item.link ?? 'Нет ссылки',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.check_circle,
              label: 'Статус',
              value: item.isReserved ? 'Зарезервировано' : 'Свободно',
            ),
          ],
        ),
      ),
      actions: [
        if (isOwner) ...[
          ElevatedButton(
            onPressed: () {
              _showEditDialog(context);
            },
            child: const Text('Редактировать'),
          ),
        ],
        // ElevatedButton(
        //   onPressed: () {
        //     // Логика для изменения статуса "Зарезервировано"
        //     Navigator.of(context).pop();
        //   },
        //   child: Text(item.isReserved ? 'Снять резерв' : 'Зарезервировать'),
        // ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Закрыть',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать пункт'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                // Логика для сохранения изменений
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}
