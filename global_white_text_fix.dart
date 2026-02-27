import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  int replacedFiles = 0;
  for (final file in files) {
    if (file.path.contains('app_theme.dart')) continue;
    
    String content = file.readAsStringSync();
    bool changed = false;

    // 1. TextStyles
    final ts1 = 'const TextStyle(color: Colors.white)';
    final ts2 = 'TextStyle(color: Colors.white)';
    final tsReplacement = 'TextStyle(color: Theme.of(context).textTheme.displayLarge?.color)';
    
    if (content.contains(ts1)) {
      content = content.replaceAll(ts1, tsReplacement);
      changed = true;
    }
    if (content.contains(ts2)) {
      content = content.replaceAll(ts2, tsReplacement);
      changed = true;
    }

    // 2. TextStyles with other props
    final ts3 = 'color: Colors.white,';
    final ts3Replacement = 'color: Theme.of(context).textTheme.displayLarge?.color,';
    
    // We only want to replace `color: Colors.white,` if it looks like it's inside a text style
    // e.g., `GoogleFonts.inter(fontSize: 14, color: Colors.white)`
    // Or `style: TextStyle(..., color: Colors.white, ...)`
    
    // Simple regex for GoogleFonts or TextStyle with color: Colors.white
    final regExp = RegExp(r'(GoogleFonts\.[a-zA-Z]+\(|TextStyle\()([^)]*)color:\s*Colors\.white([,)])');
    if (regExp.hasMatch(content)) {
      content = content.replaceAllMapped(regExp, (match) {
        return '${match.group(1)}${match.group(2)}color: Theme.of(context).textTheme.displayLarge?.color${match.group(3)}';
      });
      changed = true;
    }
    
    // Additional case for color: Colors.white)
    final regExp2 = RegExp(r'(GoogleFonts\.[a-zA-Z]+\(|TextStyle\()([^)]*)color:\s*Colors\.white\)');
    if (regExp2.hasMatch(content)) {
      content = content.replaceAllMapped(regExp2, (match) {
        return '${match.group(1)}${match.group(2)}color: Theme.of(context).textTheme.displayLarge?.color)';
      });
      changed = true;
    }

    if (changed) {
      // Remove const from enclosing Text() widgets just in case it breaks compilation
      final textRegex = RegExp(r'const Text\(');
      content = content.replaceAll(textRegex, 'Text(');
      
      final textSpanRegex = RegExp(r'const TextSpan\(');
      content = content.replaceAll(textSpanRegex, 'TextSpan(');
      
      final centerRegex = RegExp(r'const Center\(child: Text\(');
      content = content.replaceAll(centerRegex, 'Center(child: Text(');

      file.writeAsStringSync(content);
      replacedFiles++;
      print('Updated: ${file.path}');
    }
  }
  print('Total files updated: \$replacedFiles');
}
