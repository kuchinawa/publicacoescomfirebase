import 'package:flutter/material.dart';
import '../models/publicacao.dart';
import '../services/PublicacaoService.dart';

class EditarPublicacaoScreen extends StatefulWidget {
  final Publicacao publicacao;

  EditarPublicacaoScreen({required this.publicacao});

  @override
  _EditarPublicacaoScreenState createState() => _EditarPublicacaoScreenState();
}

class _EditarPublicacaoScreenState extends State<EditarPublicacaoScreen> {
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  final _imagemURLController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.publicacao.titulo;
    _conteudoController.text = widget.publicacao.conteudo;
    _imagemURLController.text = widget.publicacao.imagemURL;
  }

  Future<void> _atualizarPublicacao() async {
    String titulo = _tituloController.text;
    String conteudo = _conteudoController.text;
    String imagemURL = _imagemURLController.text;

    if (titulo.isNotEmpty && conteudo.isNotEmpty) {
      Publicacao publicacaoAtualizada = Publicacao(
        id: widget.publicacao.id,
        titulo: titulo,
        conteudo: conteudo,
        imagemURL: imagemURL,
        autor: widget.publicacao.autor,
        data: widget.publicacao.data, fotoPerfilURL: '',
      );

      await PublicacaoService().atualizarPublicacao(publicacaoAtualizada);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Publicação'),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextFormField(
            controller: _conteudoController,
            decoration: InputDecoration(labelText: 'Conteúdo'),
            maxLines: null,
          ),
          TextFormField(
            controller: _imagemURLController,
            decoration: InputDecoration(labelText: 'URL da Imagem'),
          ),
          ElevatedButton(
            onPressed: _atualizarPublicacao,
            child: Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }
}
