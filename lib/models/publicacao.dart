class Publicacao {
  final String id;
  final String titulo;
  final String conteudo;
  final String imagemURL;
  final String autor;
  final DateTime? data;
  final String fotoPerfilURL;

  Publicacao({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.imagemURL,
    required this.autor,
    this.data,
    required this.fotoPerfilURL,
  });
}
