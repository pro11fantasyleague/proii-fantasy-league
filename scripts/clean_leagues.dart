import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env.dev");
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);

  try {
    print('Deleting all league members...');
    await supabase.from('league_members').delete().neq('id', 'dummy'); // delete all
    
    print('Deleting all leagues...');
    await supabase.from('leagues').delete().neq('id', 'dummy'); // delete all
    
    print('All leagues and members successfully deleted.');
  } catch (e) {
    print('Error during cleanup: \$e');
  }
}
