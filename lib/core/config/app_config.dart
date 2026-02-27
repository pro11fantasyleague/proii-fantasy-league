import 'env_config.dart';

// Unified Environment Enum
enum Environment { dev, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  static AppConfig get instance => _instance;

  late Environment _environment;
  
  // Private constructor
  AppConfig._internal();

  // Initialization
  Future<void> init(Environment env) async {
    _environment = env;
    // Initialize EnvConfig (loads .env)
    await EnvConfig.init(env == Environment.dev ? EnvType.dev : EnvType.prod);
  }

  Environment get environment => _environment;
  
  // Convenience getters from EnvConfig
  String get supabaseUrl => EnvConfig.current.supabaseUrl;
  String get supabaseAnonKey => EnvConfig.current.supabaseAnonKey;
}
