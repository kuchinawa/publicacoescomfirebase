import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postfirebase/domain/entities/publicacao.dart';

class PublicacaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> criarPublicacao(Publicacao publicacao) async {
    await _firestore.collection('publicacoes').add({
      'titulo': publicacao.titulo,
      'conteudo': publicacao.conteudo,
      'imagemURL': publicacao.imagemURL,
      'autor': publicacao.autor,
      'data': publicacao.data,
    });
  }

  Future<List<Publicacao>> obterPublicacoes() async {
    final querySnapshot = await _firestore.collection('publicacoes').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Publicacao(
        id: doc.id,
        titulo: data['titulo'],
        conteudo: data['conteudo'],
        imagemURL: data['imagemURL'],
        autor: data['autor'],
        data: (data['data'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<void> atualizarPublicacao(Publicacao publicacao) async {
    if (_firebaseAuth.currentUser?.displayName == publicacao.autor) {
      await _firestore
          .collection('publicacoes')
          .doc(publicacao.id)
          .update({
        'titulo': publicacao.titulo,
        'conteudo': publicacao.conteudo,
        'imagemURL': publicacao.imagemURL,
      });
    } else {
      throw Exception('Você não tem permissão para atualizar esta publicação.');
    }
  }

  Future<void> excluirPublicacao(String publicacaoId) async {
    final publicacao = await _firestore
        .collection('publicacoes')
        .doc(publicacaoId)
        .get();

    if (publicacao.exists) {
      final autor = publicacao.data()?['autor'];
      if (_firebaseAuth.currentUser?.displayName == autor) {
        await _firestore.collection('publicacoes').doc(publicacaoId).delete();
      } else {
        throw Exception('Você não tem permissão para excluir esta publicação.');
      }
    } else {
      throw Exception('A publicação não existe.');
    }
  }
}
