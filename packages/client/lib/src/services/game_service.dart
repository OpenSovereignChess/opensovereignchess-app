import 'package:riverpod_annotation/riverpod_annotation.dart';

import './supabase_client.dart';

part 'game_service.g.dart';

@riverpod
class GameService extends _$GameService {
  @override
  void build() {
    // This service does not need to initialize anything at the moment.
  }

  Future<Map<String, dynamic>> createGame(String userId) async {
    final supabase = await ref.read(supabaseClientProvider.future);
    final List<Map<String, dynamic>> data =
        await supabase.from('games').insert({
      'player1_id': userId,
    }).select();
    return data[0];
  }
}
