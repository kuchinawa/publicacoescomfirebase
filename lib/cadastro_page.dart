import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'checagem_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imageURLController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro'),
      ),
      body:ListView(
        padding: EdgeInsets.all(12),
        children: [
          _buildTextField(_nomeController, 'Nome Completo'),
          _buildTextField(_emailController, 'E-mail'),
          _buildTextField(_passwordController, 'Senha', obscureText: true),
          _buildTextField(_imageURLController, 'URL da Imagem de Perfil'),
          ElevatedButton(
            onPressed: () {
              cadastrar();
            },
            child: Text('Cadastrar'),
          ),
        ],
      )
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
    );
  }

  Future<void> cadastrar() async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(_nomeController.text);

        // Update the user's profile with the image URL
        await userCredential.user!.updatePhotoURL(_imageURLController.text);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ChecagemPage(),
          ),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocorreu um erro ao cadastrar';
      if (e.code == 'weak-password') {
        errorMessage = 'Crie uma senha mais forte';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este e-mail já foi cadastrado.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

}
