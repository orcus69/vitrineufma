import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  if (!UniversalPlatform.isWeb) {
    var path = await getApplicationSupportDirectory();
    Hive.init(
      path.path,
    ); //TODO QUANDO FOR AUTERADO O BANCO DE D ADOS TROCAR AQUI, OU REMOVER
  }
  // if (isDesktop()) {
  try {
    await Future.wait([
      Hive.openBox(
        "data",
        // encryptionCipher: HiveAesCipher(encryptionKey),
      ),
    ]);
  } catch (e) {
    exit(1);
  }
  // }

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}
