import 'package:flutter/material.dart';
import 'package:flutter_cinema/app/app_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_module.dart';

void main() {
  return runApp(ModularApp(module: AppModule(), child: const AppPage()));
}
