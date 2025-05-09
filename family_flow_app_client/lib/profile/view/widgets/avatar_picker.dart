import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final Function(File) onAvatarSelected;

  const AvatarPicker({required this.onAvatarSelected, super.key});

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _selectedAvatar;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedAvatar = File(pickedFile.path);
      });
      widget.onAvatarSelected(_selectedAvatar!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage:
                _selectedAvatar != null ? FileImage(_selectedAvatar!) : null,
            child:
                _selectedAvatar == null
                    ? const Icon(Icons.camera_alt, size: 30)
                    : null,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Нажмите, чтобы выбрать аватар',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
