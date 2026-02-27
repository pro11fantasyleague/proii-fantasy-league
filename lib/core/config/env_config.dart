import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvType { dev, prod }

class EnvConfig {
  final EnvType type;
  final String supabaseUrl;
  final String supabaseAnonKey;

  const EnvConfig({
    required this.type,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  static late final EnvConfig current;

  static Future<void> init(EnvType type) async {
    final fileName = type == EnvType.dev ? '.env.dev' : '.env.prod';
    await dotenv.load(fileName: fileName);

    current = EnvConfig(
      type: type,
      supabaseUrl: dotenv.get('SUPABASE_URL'),
      supabaseAnonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }
}
