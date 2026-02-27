import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // Remove const before TextStyle if it contains Theme.of
    final regex = RegExp(r'const\s+TextStyle\(([^)]*Theme\.of[^)]*)\)');
    if (regex.hasMatch(content)) {
      content = content.replaceAllMapped(regex, (match) => 'TextStyle(${match.group(1)})');
      changed = true;
    }

    // Also just broadly remove const TextStyle if it has Theme
    // A simpler approach: replace "const TextStyle" with "TextStyle" globally where Theme.of is used on the same line or block.
    // Let's just do it file by file for safety.
    final problemRegex = RegExp(r'const\s+TextStyle\([^;}]*Theme\.of');
    if (problemRegex.hasMatch(content)) {
      // Find all 'const TextStyle' and just replace them with 'TextStyle'
      // It's safe to drop const from TextStyle in Flutter, just slightly impacts performance
      // but only if that specific widget tree has an issue.
    }
    
    // Actually, any 'const TextStyle' that is followed eventually by 'Theme.of' before a closing paren.
    // A simpler way: just remove all `const TextStyle` if the file has `Theme.of`.
    if (content.contains('const TextStyle(') && content.contains('Theme.of(context)')) {
       // Too broad? Let's fix specific known ones:
       content = content.replaceAll(RegExp(r'const\s+TextStyle\('), 'TextStyle(');
       changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Fixed const TextStyle in \${file.path}');
    }
  }
}
