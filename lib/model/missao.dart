class Missao {
  final int id;
  final DateTime data;
  final String nome;
  final bool ativa;
  Missao({
    required this.id,
    required this.data,
    required this.nome,
    required this.ativa,
  });
  Missao copyWith({int? id, DateTime? data, String? nome, bool? ativa}) {
    return Missao(
      id: id ?? this.id,
      data: data ?? this.data,
      nome: nome ?? this.nome,
      ativa: ativa ?? this.ativa,
    );
  }
}
