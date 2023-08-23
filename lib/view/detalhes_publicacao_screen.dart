import 'package:flutter/material.dart';
import 'package:postfirebase/domain/entities/publicacao.dart';
import 'package:intl/intl.dart';

class DetalhesPublicacaoScreen extends StatelessWidget {
  final Publicacao publicacao;

  DetalhesPublicacaoScreen({required this.publicacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Publicação'),
      ),
      body: Container(
        color: Colors.grey[200], // Cor de fundo cinza claro
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Título: ${publicacao.titulo}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            if (publicacao.imagemURL.isNotEmpty)
              Image.network(publicacao.imagemURL),
            SizedBox(height: 16.0),
            Text(
              'Conteúdo: ${publicacao.conteudo}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Autor: ${publicacao.autor}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Data: ${publicacao.data != null ? DateFormat('dd/MM/yyyy HH:mm').format(publicacao.data!) : "Data desconhecida"}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
