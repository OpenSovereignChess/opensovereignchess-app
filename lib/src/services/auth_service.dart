//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_client.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  Future<Session?> build() async {
    final client = ref.watch(supabaseClientProvider).value;
    return client?.auth.currentSession;
  }
}
