import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/diary_bloc.dart';
import 'widgets/widgets.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Дневник')),
      body: RefreshIndicator(
        onRefresh: () async {
          // Отправляем событие для обновления записей
          context.read<DiaryBloc>().add(DiaryRequested());
        },
        child: BlocBuilder<DiaryBloc, DiaryState>(
          builder: (context, state) {
            if (state is DiaryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DiaryLoadSuccess) {
              if (state.entries.isEmpty) {
                // Если список записей пуст, показываем сообщение
                return const Center(
                  child: Text(
                    'Записей дневника нет, создайте!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              // Если записи есть, отображаем их в списке
              return ListView.builder(
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  final entry = state.entries[index];
                  return ListTile(
                    leading: Text(
                      entry.emoji.isNotEmpty
                          ? entry.emoji
                          : '📘', // Эмодзи или значение по умолчанию
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(entry.title),
                    subtitle: Text(entry.description),
                    onTap: () {
                      // Переход в раздел редактирования при нажатии на элемент
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => DiaryEntryPage(
                                entry: entry,
                                onSave: (updatedEntry) {
                                  context.read<DiaryBloc>().add(
                                    DiaryEntryUpdated(
                                      oldEntry: entry,
                                      updatedEntry: updatedEntry,
                                    ),
                                  );
                                },
                              ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => DiaryEntryPage(
                                      entry: entry,
                                      onSave: (updatedEntry) {
                                        context.read<DiaryBloc>().add(
                                          DiaryEntryUpdated(
                                            oldEntry: entry,
                                            updatedEntry: updatedEntry,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<DiaryBloc>().add(
                              DiaryEntryDeleted(entry),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is DiaryLoadFailure) {
              return Center(
                child: Text(
                  'Ошибка загрузки дневника: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => DiaryEntryPage(
                    onSave: (newEntry) {
                      context.read<DiaryBloc>().add(DiaryEntryAdded(newEntry));
                    },
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
