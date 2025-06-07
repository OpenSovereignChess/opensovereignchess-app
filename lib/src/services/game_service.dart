import 'package:riverpod_annotation/riverpod_annotation.dart';

import './supabase_client.dart';

part 'game_service.g.dart';

@riverpod
class GameService extends _$GameService {
  @override
  void build() {
    // This service does not need to initialize anything at the moment.
  }

  Future<void> createGame(String userId) async {
    final supabase = await ref.read(supabaseClientProvider.future);
    final response = await supabase.from('games').insert({
      'player1_id': userId,
    });

    if (response.error != null) {
      throw Exception('Failed to create game: ${response.error!.message}');
    }
  }
}
