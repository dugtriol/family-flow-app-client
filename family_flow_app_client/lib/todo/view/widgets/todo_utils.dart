import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Возвращает цвет плитки в зависимости от статуса задачи.
Color getTileColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return Colors.green.withOpacity(0.1); // Светло-зеленый для Completed
    case 'active':
      return Colors.blue.withOpacity(0.1); // Светло-синий для Active
    default:
      return Colors.grey.withOpacity(0.1); // Серый для неизвестного статуса
  }
}

/// Форматирует дату в формате `день месяц` на русском языке.
String formatDate(DateTime date) {
  final formatter = DateFormat('d MMM', 'ru');
  return formatter.format(date);
}
