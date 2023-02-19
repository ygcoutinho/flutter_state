import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state/changeNotifier/imc_change_notifier_controller.dart';
import 'package:flutter_state/widgets/imc_gauge.dart';
import 'package:intl/intl.dart';

class ImcChangeNofitierPage extends StatefulWidget {
  const ImcChangeNofitierPage({Key? key}) : super(key: key);

  @override
  State<ImcChangeNofitierPage> createState() => _ImcChangeNofitierPageState();
}

class _ImcChangeNofitierPageState extends State<ImcChangeNofitierPage> {
  final pesoEC = TextEditingController();
  final alturaEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _imcController = ImcChangeNotifierController();

  @override
  void dispose() {
    pesoEC.dispose();
    alturaEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SetState'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _imcController,
                builder: (context, _) {
                  return ImcGauge(imc: _imcController.imc);
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
                    _imcController.calcularImc(peso: peso, altura: altura);
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
