import 'package:flutter/material.dart';

import '../models/publicacao.dart';

class PublicacaoScreen extends StatelessWidget {
  final Publicacao publicacao;

  PublicacaoScreen({required this.publicacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Publicação'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              publicacao.titulo,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              publicacao.conteudo,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            if (publicacao.imagemURL.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Image.network(
                  publicacao.imagemURL,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16),
            Text(
              'Autor: ${publicacao.autor}',
              style: TextStyle(fontSize: 14, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(
              'Data: ${publicacao.data.toString()}',
              style: TextStyle(fontSize: 14, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
