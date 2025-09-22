import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_service.g.dart';

@riverpod
class GameService extends _$GameService {
  @override
  void build() {
    // This service does not need to initialize anything at the moment.
  }

  Future<void> createGame(String accessToken) async {
    final baseUrl = const String.fromEnvironment('API_BASE_URL',
        defaultValue: 'http://localhost:8080');
    final response = await http.post(
      Uri.parse('$baseUrl/games'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      //return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create game: ${response.statusCode}');
    }
  }
}
