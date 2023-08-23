import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postfirebase/service/PublicacaoService.dart';
import 'package:postfirebase/view/Editar_Publicacao_Screen.dart';
import 'package:postfirebase/view/adicionar_publicacao_screen.dart';
import 'package:postfirebase/view/detalhes_publicacao_screen.dart';

import 'checagem_page.dart';
import 'domain/entities/publicacao.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PublicacaoService _publicacaoService = PublicacaoService();

  late User _user; // O usuário logado
  List<Publicacao> _publicacoes = []; // Lista de publicações

  @override
  void initState() {
    super.initState();
    _user = _firebaseAuth.currentUser!;
    _carregarPublicacoes();
  }

  Future<void> _carregarPublicacoes() async {
    final publicacoes = await _publicacaoService.obterPublicacoes();
    setState(() {
      _publicacoes = publicacoes;
    });
  }

  void _mostrarOpcoes(Publicacao publicacao) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  _editarPublicacao(publicacao);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Excluir'),
                onTap: () {
                  Navigator.pop(context);
                  _excluirPublicacao(publicacao);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editarPublicacao(Publicacao publicacao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarPublicacaoScreen(publicacao: publicacao),
      ),
    ).then((_) {
      _carregarPublicacoes();
    });
  }

  void _excluirPublicacao(Publicacao publicacao) async {
    setState(() {
      _publicacoes.remove(publicacao);
    });
    await _publicacaoService.excluirPublicacao(publicacao.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${_user.displayName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _firebaseAuth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChecagemPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: ListView.builder(
          itemCount: _publicacoes.length,
          itemBuilder: (context, index) {
            final publicacao = _publicacoes[index];
            return Card(
              color: Colors.grey[800],
              child: ListTile(
                leading: publicacao.imagemURL.isNotEmpty
                    ? Image.network(
                  publicacao.imagemURL,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : SizedBox.shrink(),
                title: Text(
                  publicacao.titulo,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Autor: ${publicacao.autor}',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalhesPublicacaoScreen(publicacao: publicacao),
                    ),
                  );
                },
                onLongPress: () {
                  if (publicacao.autor == _user.displayName) {
                    _mostrarOpcoes(publicacao);
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarPublicacaoScreen()),
          ).then((_) {
            _carregarPublicacoes();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
