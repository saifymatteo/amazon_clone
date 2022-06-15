import 'dart:developer';
import 'dart:io';

import 'package:amazon_clone/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Show a [SnackBar] function
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

// Pick multiple images function
Future<List<File>> pickImages() async {
  final images = <File>[];

  try {
    final files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (files != null && files.files.isNotEmpty) {
      for (var i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    log(e.toString());
  }

  return images;
}

// Special method to avoid warning on:
// "Do not use BuildContexts across async gaps."
UserProvider userProvider({BuildContext? context}) {
  return Provider.of(context!, listen: false);
}

// Same as above to avoid warning
void navigatePushNamed({BuildContext? context, String? routename}) {
  Navigator.pushNamedAndRemoveUntil(context!, routename!, (route) => false);
}
