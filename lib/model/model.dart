
import 'package:flutter/material.dart';

/// A classe [SuperHero] define os objetos que carregam os atributos de cada herói.
class SuperHero {
  SuperHero(
    this.id,{
      this.name = '',
      this.powerstats,
      this.biography,
      this.appearance,
      this.connections,
      this.work,
      this.url = '',
    }
  );

  final int id;
  final String name;
  final Map<dynamic, dynamic>? powerstats;
  final Map<dynamic, dynamic>? biography;
  final Map<dynamic, dynamic>? appearance;
  final Map<dynamic, dynamic>? connections;
  final Map<dynamic, dynamic>? work;
  final String url;

}

/// Classe só para definir a cor do primarySwatch
class MyColor {
  static const MaterialColor sami = MaterialColor(0xFFEF5350, <int, Color>{
       50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFF44336),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
}