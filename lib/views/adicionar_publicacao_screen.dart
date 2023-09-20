import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/publicacao.dart';
import '../services/PublicacaoService.dart';

class AdicionarPublicacaoScreen extends StatefulWidget {
  @override
  _AdicionarPublicacaoScreenState createState() =>
      _AdicionarPublicacaoScreenState();
}

class _AdicionarPublicacaoScreenState extends State<AdicionarPublicacaoScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PublicacaoService _publicacaoService = PublicacaoService();
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  final _imagemURLController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Publicação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _conteudoController,
              decoration: InputDecoration(labelText: 'Conteúdo'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _imagemURLController,
              decoration: InputDecoration(labelText: 'URL da Imagem de Capa'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _adicionarPublicacao();
              },
              child: Text('Adicionar Publicação'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _selectImage();
              },
              child: Text('Selecionar Imagem da Galeria'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _adicionarPublicacao() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      String autor = user.displayName ?? 'Autor Desconhecido';
      String titulo = _tituloController.text;
      String conteudo = _conteudoController.text;

      if (titulo.isNotEmpty && conteudo.isNotEmpty) {
        if (_imagemURLController.text.isNotEmpty) {
          final imageURL = await _uploadImageToFirebase(_imagemURLController.text);

          if (imageURL.isNotEmpty) {
            Publicacao publicacao = Publicacao(
              id: '',
              titulo: titulo,
              conteudo: conteudo,
              imagemURL: imageURL,
              autor: autor,
              data: DateTime.now(),
              fotoPerfilURL: '',
            );

            await _publicacaoService.criarPublicacao(publicacao);

            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao fazer upload da imagem. Tente novamente.'),
              ),
            );
          }
        } else {
          Publicacao publicacao = Publicacao(
            id: '',
            titulo: titulo,
            conteudo: conteudo,
            imagemURL: '',
            autor: autor,
            data: DateTime.now(),
            fotoPerfilURL: '',
          );

          await _publicacaoService.criarPublicacao(publicacao);

          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemURLController.text = pickedFile.path;
      });
    }
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;

    final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final imageName = 'publicacao_image_$currentTime.jpg';

    final Reference ref = storage.ref().child('publicacao_image').child(imageName);

    final UploadTask uploadTask = ref.putFile(File(imagePath));

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    if (taskSnapshot.state == TaskState.success) {
      final String imageURL = await taskSnapshot.ref.getDownloadURL();
      return imageURL;
    } else {
      return '';
    }
  }
}
