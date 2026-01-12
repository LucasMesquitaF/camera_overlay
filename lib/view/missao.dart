import 'package:flutter/material.dart';
import 'package:sipam_foto/database/missoes/select.dart';
import 'package:sipam_foto/database/missoes/update.dart';
import 'package:sipam_foto/model/missao.dart' as model;
import 'package:sipam_foto/view/camera.dart';

class Missao extends StatefulWidget {
  const Missao({super.key});
  @override
  State<Missao> createState() => _MissaoState();
}

class _MissaoState extends State<Missao> {
  List<model.Missao> missoes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarMissoes();
  }

  Future<void> carregarMissoes() async {
    missoes = await Select.todasMissoes();
    loading = false;
    setState(() {});
  }

  Future<void> missaoAtivada(model.Missao missao) async {
    await Update.ativar(missao);
    await carregarMissoes();
  }

  Future<void> abrirCamera(model.Missao missao) async {
    await missaoAtivada(missao);
    if (!mounted) return;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => Camera()));
    await carregarMissoes();
  }

  void abrirModalCriarMissao() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _ModalCriarMissao(
          onSalvar: (nome, ativarAgora) async {
            // depois a gente implementa
            Navigator.pop(context);
            await carregarMissoes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Missões')),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirModalCriarMissao,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: missoes.length,
              itemBuilder: (context, index) {
                final missao = missoes[index];

                return ListTile(
                  title: Text(missao.nome),
                  subtitle: missao.ativa
                      ? const Text(
                          'Missão ativa',
                          style: TextStyle(color: Colors.green),
                        )
                      : null,
                  trailing: const Icon(Icons.camera_alt),
                  onTap: () => abrirCamera(missao),
                );
              },
            ),
    );
  }
}

class _ModalCriarMissao extends StatefulWidget {
  final void Function(String nome, bool ativarAgora) onSalvar;

  const _ModalCriarMissao({required this.onSalvar});

  @override
  State<_ModalCriarMissao> createState() => _ModalCriarMissaoState();
}

class _ModalCriarMissaoState extends State<_ModalCriarMissao> {
  final nomeCtrl = TextEditingController();
  bool ativarAgora = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova missão'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nomeCtrl,
            decoration: const InputDecoration(labelText: 'Nome da missão'),
          ),
          CheckboxListTile(
            title: const Text('Ativar agora'),
            value: ativarAgora,
            onChanged: (v) => setState(() => ativarAgora = v ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSalvar(nomeCtrl.text, ativarAgora);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
