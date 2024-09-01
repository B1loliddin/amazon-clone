import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
        ),
      );

Future<List<File>> pickImages() async {
  List<File> images = [];

  try {
    final files = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);

    if (files != null && files.files.isNotEmpty) {
      for (final image in files.files) {
        images.add(File(image.path!));
      }
    }

    return images;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
