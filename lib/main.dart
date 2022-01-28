// imports nativos do flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import dos modelos
import 'package:desafio_esoft/core/styles/app_colors.dart';

// import dos pacotes
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

// import das telas
import 'package:desafio_esoft/views/home.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: AppColors.pxPurple,
  secondaryHeaderColor: AppColors.pxYellow,

  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
    ),
    backgroundColor: AppColors.pxPurple,
  ),
);

// ignore: missing_return
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // função para alterar a cor da barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.pxPurple,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // função para bloquear o giro da tela
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      title: "Desafio e-Soft",
      theme: defaultTheme,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}