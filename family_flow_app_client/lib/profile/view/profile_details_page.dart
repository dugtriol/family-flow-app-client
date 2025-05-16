import 'dart:io';

import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/profile/bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart' show User;

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late String initialName;
  late String initialEmail;
  late String initialRole;
  late String initialGender;
  late String initialBirthDate;
  late String initialAvatar;
  late String _selectedRole;
  late String _selectedGender = 'Unknown';
  late String _selectedBirthDate;
  late String? _avatarPath;
  File? _selectedAvatar;
  // late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoadSuccess) {
      final user = profileState.user;

      nameController = TextEditingController(text: user.name);
      emailController = TextEditingController(text: user.email);

      initialName = user.name;
      initialEmail = user.email;
      initialRole = user.role;
      initialGender = user.gender;
      initialBirthDate = user.birthDate?.toIso8601String() ?? '';
      initialAvatar = user.avatar ?? '';

      _selectedRole = user.role;
      _selectedGender = user.gender;
      _selectedBirthDate = user.birthDate?.toIso8601String() ?? '';
      _avatarPath = null; // Инициализация пути к аватару
    } else {
      nameController = TextEditingController();
      emailController = TextEditingController();

      initialName = '';
      initialEmail = '';
      initialRole = 'Unknown';
      initialGender = 'Unknown';
      initialBirthDate = '';
      initialAvatar = '';

      _selectedRole = 'Unknown';
      _selectedGender = 'Unknown'; // Значение по умолчанию
      _selectedBirthDate = '';
      _avatarPath = null; // Инициализация пути к аватару
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedAvatar = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfileIfChanged() async {
    print('Updating profile...');
    final currentName = nameController.text;
    final currentEmail = emailController.text;

    // Преобразуем дату в формат YYYY-MM-DD
    final formattedBirthDate =
        _selectedBirthDate.isNotEmpty
            ? DateTime.parse(
              _selectedBirthDate,
            ).toIso8601String().split('T').first
            : '';

    if (currentName != initialName ||
        currentEmail != initialEmail ||
        _selectedRole != initialRole ||
        _selectedGender != initialGender ||
        formattedBirthDate != initialBirthDate ||
        _selectedAvatar != null) {
      print('Profile data changed. Updating...');
      context.read<ProfileBloc>().add(
        ProfileUpdateRequested(
          name: currentName,
          email: currentEmail,
          role: _selectedRole,
          gender: _selectedGender,
          birthDate: formattedBirthDate, // Передаем отформатированную дату
          avatar: _selectedAvatar?.path ?? '',
          avatarUrl: _selectedAvatar != null ? 'empty' : initialAvatar,
        ),
      );

      // Обновляем начальные значения
      initialName = currentName;
      initialEmail = currentEmail;
      initialRole = _selectedRole;
      initialGender = _selectedGender;
      initialBirthDate = formattedBirthDate;
      initialAvatar = _selectedAvatar != null ? 'empty' : initialAvatar;
      _avatarPath = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileBloc>().state;

    if (profileState is! ProfileLoadSuccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Данные пользователя')),
        body: const Center(
          child: Text('Не удалось загрузить данные пользователя.'),
        ),
      );
    }

    final user = profileState.user;

    return WillPopScope(
      onWillPop: () async {
        // await _updateProfileIfChanged();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Профиль',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () async {
              // await _updateProfileIfChanged();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(ProfileRequested());
            await Future.delayed(
              const Duration(seconds: 1),
            ); // Для имитации загрузки
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _selectedAvatar != null
                              ? FileImage(_selectedAvatar!)
                              : (initialAvatar.isNotEmpty
                                  ? NetworkImage(initialAvatar) as ImageProvider
                                  : null),
                      child:
                          _selectedAvatar == null && initialAvatar.isEmpty
                              ? const Icon(Icons.camera_alt, size: 30)
                              : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Нажмите, чтобы изменить аватар',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.key, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'ID пользователя',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: user.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'ID скопирован в буфер обмена!',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        // Поле для имени
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Имя',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Поле для email
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: emailController,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.work, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  ToggleButtons(
                                    isSelected: [
                                      _selectedRole == 'Parent',
                                      _selectedRole == 'Child',
                                    ],
                                    onPressed: (index) {
                                      index = user.role == 'Parent' ? 0 : 1;
                                      _selectedRole ==
                                          (index == 0 ? 'Parent' : 'Child');
                                      // setState(() {
                                      //   if (_selectedRole ==
                                      //       (index == 0 ? 'Parent' : 'Child')) {
                                      //     _selectedRole =
                                      //         'Unknown'; // Сбрасываем выбор
                                      //   } else {
                                      //     _selectedRole =
                                      //         index == 0 ? 'Parent' : 'Child';
                                      //   }
                                      // });
                                    },
                                    // onPressed: null,
                                    borderRadius: BorderRadius.circular(8),
                                    selectedColor: Colors.white,
                                    fillColor: Colors.deepPurple,
                                    color: Colors.deepPurple,
                                    constraints: const BoxConstraints(
                                      minHeight: 40,
                                      minWidth: 120,
                                    ),
                                    children: const [
                                      Text('👨‍👩‍👧 Родитель'),
                                      Text('🧒 Ребёнок'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  ToggleButtons(
                                    isSelected: [
                                      _selectedGender == 'Male',
                                      _selectedGender == 'Female',
                                    ],
                                    onPressed: (index) {
                                      setState(() {
                                        if (_selectedGender ==
                                            (index == 0 ? 'Male' : 'Female')) {
                                          _selectedGender =
                                              'Unknown'; // Сбрасываем выбор
                                        } else {
                                          _selectedGender =
                                              index == 0 ? 'Male' : 'Female';
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    selectedColor: Colors.white,
                                    fillColor: Colors.deepPurple,
                                    color: Colors.deepPurple,
                                    constraints: const BoxConstraints(
                                      minHeight: 40,
                                      minWidth: 120,
                                    ),
                                    children: const [
                                      Text('👨 Мужской'),
                                      Text('👩 Женский'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedBirthDate.isNotEmpty
                                                ? DateTime.parse(
                                                  _selectedBirthDate,
                                                )
                                                : DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                        locale: const Locale(
                                          'ru',
                                          'RU',
                                        ), // Устанавливаем локаль на русский
                                      );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _selectedBirthDate =
                                          pickedDate.toIso8601String();
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(
                                      text:
                                          _selectedBirthDate.isNotEmpty
                                              ? DateFormat(
                                                'dd.MM.yyyy',
                                                'ru_RU',
                                              ).format(
                                                DateTime.parse(
                                                  _selectedBirthDate,
                                                ),
                                              )
                                              : '',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Дата рождения',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Кнопка сохранения изменений
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _updateProfileIfChanged();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Изменения сохранены!'),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              'Сохранить',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
