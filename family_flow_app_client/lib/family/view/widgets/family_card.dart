// ignore_for_file: use_build_context_synchronously

import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../family.dart';

class FamilyCard extends StatefulWidget {
  final String familyName;
  final String familyId;
  final String? familyPhotoUrl; // URL фотографии семьи (может быть null)

  const FamilyCard({
    required this.familyName,
    required this.familyId,
    this.familyPhotoUrl,
    super.key,
  });

  @override
  State<FamilyCard> createState() => _FamilyCardState();
}

class _FamilyCardState extends State<FamilyCard> {
  // String? _localPhotoPath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final photo = File(pickedFile.path);

      context.read<FamilyBloc>().add(
        FamilyPhotoUpdateRequested(familyId: widget.familyId, photo: photo),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Фото успешно загружено')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoToShow = widget.familyPhotoUrl;
    print('Photo URL: $photoToShow');

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фотография семьи
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child:
                    photoToShow != null && photoToShow.isNotEmpty
                        ? Image.network(
                          photoToShow,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                        : Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: 'Изменить фото',
                  onPressed: _pickImage,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Имя семьи
                Text(
                  widget.familyName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Идентификатор семьи и кнопка копирования
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Идентификатор:',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 20,
                            color: Colors.deepPurple,
                          ),
                          tooltip: 'Скопировать идентификатор',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.familyId),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Идентификатор скопирован'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
