import 'package:flutter/material.dart';
import 'package:diary_api/diary_api.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

class EmojiInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Разрешаем ввод любых символов, включая эмодзи
    final regex = RegExp(
      r'^[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]+$',
      unicode: true,
    );

    if (newValue.text.isEmpty || regex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class DiaryEntryPage extends StatefulWidget {
  const DiaryEntryPage({super.key, this.entry, required this.onSave});

  final DiaryItem? entry;
  final void Function(DiaryItem) onSave;

  @override
  State<DiaryEntryPage> createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends State<DiaryEntryPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _emojiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.description;
      _emojiController.text = widget.entry!.emoji;
    } else {
      _titleController.text = DateFormat(
        'd MMMM yyyy',
        'ru',
      ).format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = widget.entry?.createdAt ?? DateTime.now();
    final updatedAt = widget.entry?.updatedAt ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entry == null ? 'Создать запись' : 'Редактировать запись',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Содержание'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emojiController,
              decoration: const InputDecoration(labelText: 'Добавьте эмодзи!'),
              inputFormatters: [EmojiInputFormatter()], // Ограничение ввода
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                final emoji = _emojiController.text.trim();
                if (title.isEmpty || content.isEmpty || emoji.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Заполните все поля')),
                  );
                  return;
                }
                widget.onSave(
                  DiaryItem(
                    id: widget.entry?.id ?? '',
                    title: title,
                    description: content,
                    emoji: emoji,
                    createdBy: widget.entry?.createdBy ?? '',
                    createdAt: widget.entry?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
            const SizedBox(height: 24),
            Text(
              'Дата создания: ${DateFormat('d MMMM yyyy, HH:mm', 'ru').format(createdAt)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Дата обновления: ${DateFormat('d MMMM yyyy, HH:mm', 'ru').format(updatedAt)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
