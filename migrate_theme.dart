import 'dart:io';

void main() {
  final dir = Directory('C:/Users/Ahbou/.gemini/antigravity/scratch/lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in files) {
    if (file.path.contains('app_theme.dart') || file.path.contains('settings_screen.dart')) continue;
    
    String content = file.readAsStringSync();
    bool changed = false;
    
    if (content.contains('AppColors.bg')) {
      content = content.replaceAll('AppColors.bg', 'Theme.of(context).scaffoldBackgroundColor');
      changed = true;
    }
    if (content.contains('AppColors.card')) {
      content = content.replaceAll('AppColors.card', 'Theme.of(context).colorScheme.surface');
      changed = true;
    }
    
    if (changed) {
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
