import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';

int _toColorChannel(double value) {
  return (value * 255).round().clamp(0, 255).toInt();
}

Color strengthenColor(Color color, double factor) {
  final r = _toColorChannel(color.r * factor);
  final g = _toColorChannel(color.g * factor);
  final b = _toColorChannel(color.b * factor);
  final a = _toColorChannel(color.a);

  return Color.fromARGB(a, r, g, b);
}

String rgbToHex(Color color) {
  final r = _toColorChannel(color.r);
  final g = _toColorChannel(color.g);
  final b = _toColorChannel(color.b);

  return '${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

Future<File?> selectImage() async {
  final imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  if (file != null) {
    return File(file.path);
  }
  return null;
}
