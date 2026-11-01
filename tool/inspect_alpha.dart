// ignore_for_file: avoid_print

import 'dart:io';

import 'package:image/image.dart' as img;

void report(String path) {
  final f = File(path);
  if (!f.existsSync()) {
    print('MISSING: $path');
    return;
  }
  final im = img.decodePng(f.readAsBytesSync());
  if (im == null) {
    print('UNDECODABLE: $path');
    return;
  }
  final w = im.width, h = im.height;
  int transparent = 0, opaque = 0, partial = 0;
  for (final p in im) {
    final a = p.a;
    if (a == 0) {
      transparent++;
    } else if (a == 255) {
      opaque++;
    } else {
      partial++;
    }
  }
  final total = w * h;
  // Sample corners and center
  String px(int x, int y) {
    final p = im.getPixel(x, y);
    return '(${p.r},${p.g},${p.b},${p.a})';
  }

  print('$path  ${w}x$h');
  print(
    '  alpha: transparent=${(100 * transparent / total).toStringAsFixed(1)}% '
    'partial=${(100 * partial / total).toStringAsFixed(1)}% '
    'opaque=${(100 * opaque / total).toStringAsFixed(1)}%',
  );
  print(
    '  corners TL${px(0, 0)} TR${px(w - 1, 0)} BL${px(0, h - 1)} '
    'BR${px(w - 1, h - 1)} center${px(w ~/ 2, h ~/ 2)}',
  );
}

void main(List<String> args) {
  for (final a in args) {
    report(a);
  }
}
