import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/diary_bloc.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник'),
      ),
      body: BlocBuilder<DiaryBloc, DiaryState>(
        builder: (context, state) {
          if (state is DiaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DiaryLoadSuccess) {
            return ListView.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final entry = state.entries[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text(entry.content),
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
    );
  }
}