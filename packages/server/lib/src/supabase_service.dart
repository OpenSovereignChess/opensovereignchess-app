import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:supabase/supabase.dart' show SupabaseClient;

final env = DotEnv()..load(['.env']);

class SupabaseService {
  late final SupabaseClient _client;
  late final String _jwtSecret;

  SupabaseService() {
    final supabaseUrl = env['SUPABASE_URL'];
    final supabaseKey = env['SUPABASE_SERVICE_KEY'];
    final jwtSecret = env['SUPABASE_JWT_SECRET'];

    if (supabaseUrl == null || supabaseKey == null || jwtSecret == null) {
      throw Exception('Supabase environment variables are not set.');
    }

    _client = SupabaseClient(supabaseUrl, supabaseKey);
    _jwtSecret = jwtSecret;
  }

  SupabaseClient get client => _client;
  String get jwtSecret => _jwtSecret;

  //Future<String> getUserFromAuthHeader(String authHeaderValue) async {
  //  final parts = authHeaderValue.split(' ');
  //  return await _client.getUser(parts[1]);
  //}

  Future<List<Map<String, dynamic>>> createGame(String userId) async {
    final data = await _client.from('games').insert({
      'player1_id': userId,
    }).select();
    return List<Map<String, dynamic>>.from(data as List);
  }
}
