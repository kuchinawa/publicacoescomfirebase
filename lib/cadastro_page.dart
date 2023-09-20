import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final _imagePathController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _imagePathController.text = _imagePath ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_nomeController, 'Nome Completo'),
            SizedBox(height: 16),
            _buildTextField(_emailController, 'E-mail'),
            SizedBox(height: 16),
            _buildTextField(_passwordController, 'Senha', obscureText: true),
            SizedBox(height: 16),
            _buildImagePicker(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                cadastrar();
              },
              child: Text('Cadastrar'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.green[100],
      ),
      obscureText: obscureText,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _imagePathController,
                decoration: InputDecoration(
                  labelText: 'Caminho da Imagem',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[100],
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: _selectImage,
              icon: Icon(Icons.camera_alt),
              color: Colors.blue,
            ),
          ],
        ),
        SizedBox(height: 8),
        if (_imagePath != null)
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: ClipOval(
                child: Image.file(
                  File(_imagePath!),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
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

        if (_imagePath != null) {
          final photoURL = await _uploadImageToFirebase(_imagePath!);
          await userCredential.user!.updatePhotoURL(photoURL);
        }

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

  Future<String> _uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;

    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final imageName = 'profile_image_$currentTime.jpg';

    final Reference ref = storage.ref().child('profile_images').child(imageName);

    final UploadTask uploadTask = ref.putFile(File(imagePath));

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    if (taskSnapshot.state == TaskState.success) {
      final String imageURL = await taskSnapshot.ref.getDownloadURL();
      return imageURL;
    } else {
      return '';
    }
  }
}
