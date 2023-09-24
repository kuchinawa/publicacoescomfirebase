import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna o usuário atualmente autenticado
  User? get currentUser => _auth.currentUser;

  // Realiza o login com e-mail e senha
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Lidar com erros de autenticação
      print('Erro no login: $e');
      return null;
    }
  }

  // Realiza o logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Verifica se há um usuário autenticado
  bool get isSignedIn => _auth.currentUser != null;
}
