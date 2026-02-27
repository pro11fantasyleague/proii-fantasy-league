import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/storage/hive_service.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.instance.init(Environment.prod);
  await HiveService.init();

  await Supabase.initialize(
    url: AppConfig.instance.supabaseUrl,
    anonKey: AppConfig.instance.supabaseAnonKey,
  );
  
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://31d62779191c31e3d3414460cde8fc92@o4510914911928320.ingest.de.sentry.io/4510914924380240';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      const ProviderScope(
        child: ProIIApp(),
      ),
    ),
  );
}

