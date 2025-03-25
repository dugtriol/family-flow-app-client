import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:authentication_repository/authentication_repository.dart';

import '../bloc/task_overview_bloc.dart';

class TaskOverviewPage extends StatelessWidget {
  const TaskOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository =
        RepositoryProvider.of<AuthenticationRepository>(context);

    return BlocProvider(
      create: (_) =>
          TaskOverviewBloc(authenticationRepository: authenticationRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Overview'),
        ),
        body: Center(
          child: _LogoutButton(),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TaskOverviewBloc>().add(TaskOverviewLogoutRequested());
      },
      child: const Text('Logout'),
    );
  }
}
