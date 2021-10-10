import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sami/view/home.dart';
import 'package:sami/view/state.dart';
import 'model/model.dart';

/// Variáveis globais e imutáveis
const int kQueryLimit  = 8;
const int kAccessToken = 6130951053642291;
const String kAuthorName  = 'Erick Kronemberger';
const String kAuthorEmail = 'erick.kronemberger@gmail.com';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sami',
      theme: ThemeData(
        primarySwatch: MyColor.sami,
      ),
      /// Não é ideal posicionar o [ChangeNotifierProvider] tão alto na árvore mas, 
      /// a título de demonstração, este é o único lugar em que é possível
      /// acessar adequadamente os widgets descendentes.
      home: ChangeNotifierProvider<ListNotifier>(
      create: (BuildContext _) => ListNotifier(),
      builder: (context, _) =>  const MyHomePage(title: 'sami'),)
    );
  }
}

