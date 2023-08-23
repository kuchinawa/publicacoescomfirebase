class Publicacao {
  final String id;
  final String titulo;
  final String conteudo;
  final String imagemURL;
  final String autor;
  final DateTime data;

  Publicacao({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.imagemURL,
    required this.autor,
    required this.data,
  });
}
