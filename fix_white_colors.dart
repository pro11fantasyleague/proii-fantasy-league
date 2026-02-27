import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  int replacedCount = 0;

  for (final file in files) {
    if (file.path.contains('app_theme.dart')) continue;

    String content = file.readAsStringSync();
    
    // Replace `color: Colors.white` only when it's inside text styling
    // Because it's too risky to do it everywhere due to `const`.
    // Wait, removing `const` is the crucial part.
    // Let's replace `const TextStyle(color: Colors.white)` with `TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white)`
    // And `const Text(` with `Text(` (basic ones)
    
    bool changed = false;
    
    // 1. TextStyle
    if (content.contains('const TextStyle(color: Colors.white)')) {
      content = content.replaceAll('const TextStyle(color: Colors.white)', 'TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white)');
      changed = true;
    }
    if (content.contains('TextStyle(color: Colors.white)')) {
      content = content.replaceAll('TextStyle(color: Colors.white)', 'TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white)');
      changed = true;
    }

    // 2. GoogleFonts
    if (content.contains('color: Colors.white')) {
      // It's hard to target just GoogleFonts without breaking things.
      // Let's just do it manually for Hub, News, Scores, Draft, Settings where it matters most.
    }
  }
}
