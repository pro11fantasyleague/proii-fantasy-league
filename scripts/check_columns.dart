import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env.dev");
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);

  try {
    // Attempt to select 1 row just to see what columns come back, or use postgrest reflection
    final response = await supabase.from('profiles').select().limit(1);
    
    print('Profiles data sample: \$response');
    
    // Test updating a random pseudo user with no real change to see if it triggers the same PGRST204
    try {
      await supabase.from('profiles').update({'username': 'test'}).eq('id', '00000000-0000-0000-0000-000000000000');
      print('Update username dry run succeeded (or found no rows). Column exists!');
    } catch (e) {
      print('Update error: \$e');
    }
  } catch (e) {
    print('Error: \$e');
  }
}
