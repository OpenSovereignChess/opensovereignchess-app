import 'package:supabase/supabase.dart' show SupabaseClient;

class SupabaseService {
  late final SupabaseClient _client;
  late final String _jwtSecret;

  SupabaseService() {
    final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
    final supabaseKey = const String.fromEnvironment('SUPABASE_SERVICE_KEY');
    final jwtSecret = const String.fromEnvironment('SUPABASE_JWT_SECRET');

    if (supabaseUrl.isEmpty || supabaseKey.isEmpty || jwtSecret.isEmpty) {
      throw Exception('Supabase environment variables are not set.');
    }

    _client = SupabaseClient(supabaseUrl, supabaseKey);
    _jwtSecret = jwtSecret;
  }

  SupabaseClient get client => _client;
  String get jwtSecret => _jwtSecret;

  Future<List<Map<String, dynamic>>> createGame(String userId) async {
    final data = await _client.from('games').insert({
      'player1_id': userId,
    }).select();
    return List<Map<String, dynamic>>.from(data as List);
  }
}
