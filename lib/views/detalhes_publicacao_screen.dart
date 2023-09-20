import 'package:flutter/material.dart';

import '../models/publicacao.dart';

class DetalhesPublicacaoScreen extends StatelessWidget {
  final Publicacao publicacao;

  DetalhesPublicacaoScreen({required this.publicacao});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Publicação'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(publicacao.fotoPerfilURL),
                ),
              ),

              SizedBox(height: 16.0),


              Text(
                'Autor: ${publicacao.autor}',
                style: TextStyle(fontSize: 16.0),
              ),

              SizedBox(height: 16.0),


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
                'Data: ${publicacao.data != null ? formatRelativeTime(publicacao.data!) : "Data desconhecida"}',
                style: TextStyle(fontSize: 16.0),
              ),

              SizedBox(height: 16.0),
            ],
          );
        },
      ),
    );
  }

  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'há ${difference.inSeconds} segundos atrás';
    } else if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes} minutos atrás';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours} horas atrás';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      return 'há $days dias e $hours horas atrás';
    }
  }
}
