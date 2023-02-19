import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state/widgets/imc_gauge.dart';
import 'package:intl/intl.dart';

class ImcValueNotifierPage extends StatefulWidget {
  const ImcValueNotifierPage({Key? key}) : super(key: key);

  @override
  State<ImcValueNotifierPage> createState() => _ImcValueNotifierPageState();
}

class _ImcValueNotifierPageState extends State<ImcValueNotifierPage> {
  final pesoEC = TextEditingController();
  final alturaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _imc = ValueNotifier(0.0);

  @override
  void dispose() {
    pesoEC.dispose();
    alturaEC.dispose();
    super.dispose();
  }

  void _calcularIMC(double altura, double peso) {
    _imc.value = peso / pow(altura, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Value Notifier'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _imc,
                builder: (_, value, __) {
                  return ImcGauge(imc: value);
                },
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Peso obrigatório';
                        }
                        return null;
                      },
                      controller: pesoEC,
                      decoration: const InputDecoration(labelText: 'Peso'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'pt_BR',
                          decimalDigits: 2,
                          symbol: '',
                          turnOffGrouping: true,
                        ),
                      ],
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Altura obrigatória';
                        }
                        return null;
                      },
                      controller: alturaEC,
                      decoration: const InputDecoration(labelText: 'Altura'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'pt_BR',
                          decimalDigits: 2,
                          symbol: '',
                          turnOffGrouping: true,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  var formValid = formKey.currentState?.validate() ?? false;
                  if (formValid) {
                    var formatter = NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);
                    var altura = formatter.parse(alturaEC.text) as double;
                    var peso = formatter.parse(pesoEC.text) as double;
                    _calcularIMC(altura, peso);
                  }
                },
                child: const Text('Calcular IMC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
