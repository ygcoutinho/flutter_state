import 'dart:math';

import 'package:flutter/material.dart';

class ImcChangeNotifierController extends ChangeNotifier {
  var imc = 0.0;

  Future<void> calcularImc({required double peso, required double altura}) async {
    imc = peso / pow(altura, 2);
    notifyListeners();
  }
}
