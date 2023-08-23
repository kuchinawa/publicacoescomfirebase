import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postfirebase/service/PublicacaoService.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/entities/publicacao.dart';

class AdicionarPublicacaoScreen extends StatefulWidget {
  @override
  _AdicionarPublicacaoScreenState createState() => _AdicionarPublicacaoScreenState();
}

class _AdicionarPublicacaoScreenState extends State<AdicionarPublicacaoScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PublicacaoService _publicacaoService = PublicacaoService();
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  final _imagemURLController = TextEditingController();

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
      String imagemURL = _imagemURLController.text;

      if (titulo.isNotEmpty && conteudo.isNotEmpty) {
        Publicacao publicacao = Publicacao(
          id: '', // O ID será gerado automaticamente pelo Firebase
          titulo: titulo,
          conteudo: conteudo,
          imagemURL: imagemURL,
          autor: autor,
          data: DateTime.now(),
        );

        await _publicacaoService.criarPublicacao(publicacao);

        Navigator.pop(context); // Volta para a tela anterior
      }
    }
  }
}
