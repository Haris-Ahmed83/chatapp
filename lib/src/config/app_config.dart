import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static late final SupabaseClient supabase;

  static Future<void> init() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
    supabase = Supabase.instance.client;
  }

  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
