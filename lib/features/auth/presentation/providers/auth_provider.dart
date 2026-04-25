import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../hinario/presentation/providers/hinario_providers.dart'; // Onde está o apiClientProvider
import '../../domain/models/auth_user.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> build() {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Obtém o token atual do Firebase para enviar ao backend
  Future<String?> getIdToken() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }
}

/// Provider para os dados do utilizador vindos da nossa API (Django)
@Riverpod(keepAlive: true)
Future<AuthUser?> currentUser(Ref ref) async {
  final authState = ref.watch(authProvider);
  
  return authState.when(
    data: (firebaseUser) async {
      if (firebaseUser == null) return null;
      
      final dio = ref.read(apiClientProvider).client;
      try {
        final response = await dio.get('/users/me/', queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch,
        });
        return AuthUser.fromJson(response.data);
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
