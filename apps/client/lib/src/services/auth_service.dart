//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  SupabaseClient build() {
    return Supabase.instance.client;
  }

  Future<void> signInAnonymously() async {
    await Supabase.instance.client.auth.signInAnonymously();
  }

  User? get currentUser {
    return Supabase.instance.client.auth.currentUser;
  }

  Session? get currentSession {
    return Supabase.instance.client.auth.currentSession;
  }
}
