//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_client.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  Future<Session?> build() async {
    final supabase = await ref.read(supabaseClientProvider.future);
    return supabase.auth.currentSession;
  }

  Future<void> signInAnonymously() async {
    final supabase = await ref.read(supabaseClientProvider.future);
    await supabase.auth.signInAnonymously();
  }

  Future<User?> get currentUser async {
    final supabase = await ref.read(supabaseClientProvider.future);
    return supabase.auth.currentUser;
  }
}
