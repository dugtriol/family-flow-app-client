import 'package:flutter/material.dart';
import 'package:shopping_api/shopping_api.dart';

class ShoppingDetailsDialog extends StatelessWidget {
  const ShoppingDetailsDialog({
    super.key,
    required this.item,
    required this.isOwner,
  });

  final ShoppingItem item;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Закруглённые углы
      ),
      title: Row(
        children: [
          const Icon(Icons.info, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
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
              value:
                  item.description.isNotEmpty
                      ? item.description
                      : 'Без описания',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.visibility,
              label: 'Видимость',
              value: item.visibility,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person,
              label: 'Создатель',
              value: item.createdBy,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.date_range,
              label: 'Дата создания',
              value: item.createdAt.toString(),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.check_circle,
              label: 'Статус',
              value: item.status == 'Reserved' ? 'Зарезервировано' : 'Свободно',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Редактировать',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        ElevatedButton(
          onPressed: () {
            // Логика для изменения статуса "Зарезервировано"
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                item.status == 'Reserved' ? Colors.red : Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            item.status == 'Reserved' ? 'Снять резерв' : 'Зарезервировать',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Закрыть',
            style: TextStyle(color: Colors.deepPurple),
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
        Icon(icon, color: Colors.deepPurple),
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
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: item.title);
    final descriptionController = TextEditingController(text: item.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Редактировать пункт',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
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
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Логика для сохранения изменений
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
