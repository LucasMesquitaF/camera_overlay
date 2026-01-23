import 'package:flutter/material.dart';
import 'package:sipam_foto/model/filtro.dart' as model;

class Filtros extends StatefulWidget {
  final model.Filtro filtro;
  const Filtros({super.key, required this.filtro});

  @override
  State<Filtros> createState() => _FiltrosState();
}

class _FiltrosState extends State<Filtros> {
  late model.Filtro filtro;
  final _input = TextEditingController();
  DateTime? _inicio;
  DateTime? _fim;
  double? _min = 0;
  double? _max = 2000;
  RangeValues _altitudeRange = const RangeValues(0, 2000);
  int? _missaoid;

  @override
  void initState() {
    super.initState();
    filtro = widget.filtro;
  }

  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(c).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          TextField(
            decoration: const InputDecoration(labelText: 'Nome'),
            onChanged: (v) {
              filtro = filtro.copyWith(nome: v.isEmpty ? null : v);
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () async {
              _inicio = await showDatePicker(
                context: c,
                initialDate: filtro.inicio ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (_inicio != null) {
                setState(() {
                  filtro = filtro.copyWith(inicio: _inicio);
                });
              }
            },
            child: Text(
              filtro.inicio == null
                  ? 'Data inicial'
                  : 'Início: ${filtro.inicio!.day}/${filtro.inicio!.month}/${filtro.inicio!.year}',
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              _fim = await showDatePicker(
                context: c,
                initialDate: filtro.fim ?? DateTime.now(),
                firstDate: filtro.inicio ?? DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (_fim != null) {
                setState(() {
                  filtro = filtro.copyWith(fim: _fim);
                });
              }
            },
            child: Text(
              filtro.fim == null
                  ? 'Data final'
                  : 'Fim: ${filtro.fim!.day}/${filtro.fim!.month}/${filtro.fim!.year}',
            ),
          ),
          RangeSlider(
            values: _altitudeRange,
            min: 0,
            max: 2000,
            divisions: 1000,
            labels: RangeLabels(
              '${_altitudeRange.start.round()}m',
              '${_altitudeRange.end.round()}m',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _altitudeRange = values;
                filtro = filtro.copyWith(
                  minimo: values.start,
                  maximo: values.end,
                );
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(c, model.Filtro.empty);
                  },
                  child: const Text('Limpar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(c, filtro);
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
