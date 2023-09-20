import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postfirebase/checagem_page.dart';
import 'package:postfirebase/services/PublicacaoService.dart';
import 'package:postfirebase/views/adicionar_publicacao_screen.dart';
import 'package:postfirebase/views/detalhes_publicacao_screen.dart';
import 'package:postfirebase/views/editar_publicacao_Screen.dart';
import 'models/publicacao.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PublicacaoService _publicacaoService = PublicacaoService();

  late User? _user;
  List<Publicacao> _publicacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _carregarPublicacoes();
  }

  Future<void> _carregarUsuario() async {
    _user = _firebaseAuth.currentUser;
  }

  Future<void> _carregarPublicacoes() async {
    final publicacoes = await _publicacaoService.obterPublicacoes();
    setState(() {
      _publicacoes = publicacoes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${_user?.displayName}'),
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
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _publicacoes.length,
          itemBuilder: (context, index) {
            final publicacao = _publicacoes[index];
            final isAuthor = publicacao.autor == _user?.displayName;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetalhesPublicacaoScreen(publicacao: publicacao),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(publicacao.imagemURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isAuthor)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editarPublicacao(publicacao);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _excluirPublicacao(publicacao);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
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
}
