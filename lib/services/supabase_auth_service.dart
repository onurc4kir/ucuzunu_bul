import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final GoTrueClient _auth = Supabase.instance.client.auth;

  Future<User?> signInWithMailAndPassword({
    required String mail,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: mail,
      password: password,
    );
    return response.user;
  }

  Future<User?> signUpWithMailAndPassword({
    required String mail,
    required String password,
  }) async {
    final response = await _auth.signUp(
      email: mail,
      password: password,
    );
    return response.user;
  }

  Future<void> sendPasswordRenewMail(String mail) async {
    return await _auth.resetPasswordForEmail(mail);
  }

  User? currentUser() => _auth.currentUser;

  Future<void> signOut() async => await _auth.signOut();

  Future<void> updateMail(String mail) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _auth.updateUser(UserAttributes(email: mail));
    }
  }
}
