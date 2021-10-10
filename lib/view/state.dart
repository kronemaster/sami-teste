import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sami/main.dart';
import 'package:sami/model/model.dart';

/// A classe ChangeNotifier é a que controla as alterações de estado
class ListNotifier extends ChangeNotifier {

  /// Variável private para paginação
  int _queryLimit = kQueryLimit;

  /// Variáveis de pesquisa
  String? _searchBy;
  bool _greaterThan = false;
  int _value = 0;

  /// Variáveis de estado
  List<SuperHero> _heroes = [];
  bool _isLoading = true;
  bool _searchFilled = false;
  bool _error = false;

  List<SuperHero> get heroes => _heroes;
  bool get isLoading => _isLoading;
  bool get searchFilled => _searchFilled;
  bool get error => _error;
  
  set heroes(List<SuperHero>newVal) {
    _heroes = List<SuperHero>.from(newVal);
    notifyListeners();
  }

  /// Para pesquisa por poderes
  void setVariables({
    String? searchBy,
    bool greaterThan = false,
    int value = 0,
  }){
    _searchBy    = searchBy;
    _greaterThan = greaterThan;
    _value       = value;
  }
  
  /// Para preencher a lista de heróis
  Future<bool?> fill({
    bool paginate = false,
  }) async {

    int _index = 1;

    /// Para informar ao usuário sobre o processo de paginação,
    /// foi adicionado um [CircularProgressIndicator] que deve
    /// ser atualizado de acordo com a chamada, por isso define-se 
    /// [_isLoading].
    if(paginate) {
      _index = _queryLimit + 1;
      _queryLimit += kQueryLimit;
      _isLoading = true;
      notifyListeners();
    } else {
      _heroes.clear();
    }

    while(_index <= _queryLimit){
      /// Para controle se todos os ids são de fato chamados.
      debugPrint(_index.toString());

      await http.get(Uri.parse('https://superheroapi.com/api/$kAccessToken/$_index')).then((res) {
        
        Map data = jsonDecode(res.body) ?? ({});

        SuperHero _singleHero = SuperHero(
          _index,
          name:        data['name']         ?? '',
          powerstats:  data['powerstats']   ?? ({}),
          biography:   data['biography']    ?? ({}),
          appearance:  data['appearance']   ?? ({}),
          connections: data['connections']  ?? ({}),
          work:        data['work']         ?? ({}),
          url:         data['image']['url'] ?? ''
        );
        
        /// Para filtrar os resultados da pesquisa por poderes
        if(_searchBy != null) {
          if(_greaterThan) {
            if((int.tryParse(data['powerstats'][_searchBy]) ?? 0) >= _value) _heroes.add(_singleHero);
          } else {
            if((int.tryParse(data['powerstats'][_searchBy]) ?? 0) <= _value) _heroes.add(_singleHero);
          }
        } else {
          _isLoading = true;
          _heroes.add(_singleHero);
        }

        _index ++;

        /// O notifyListeners dentro do loop faz com que a 
        /// lista seja atualizada dinamicamente, reduzindo
        /// o tempo de espera do usuário. - performance
        notifyListeners();

        return true;

      }).catchError((e) {
        _error = true;
        return false;
      });
    }

    _isLoading = false;

    notifyListeners();

  }

  /// Para pesquisa por nome
  void search(String? val) async {
    
    _isLoading = true;
    _heroes.clear();
    notifyListeners();

    /// Caso o campo de pesquisa esteja de fato vazio 
    /// ou o usuário queira cancelar a pesquisa.
    if(val == null || val == '') {
      _searchFilled = false;
      fill();
    } else {
      _searchFilled = true;
      /// [http]
      await http.get(Uri.parse('https://superheroapi.com/api/$kAccessToken/search/$val')).then((res) {
        
        /// [dart:convert]
        Map data = jsonDecode(res.body);
        
        _heroes = List<SuperHero>.from(data['results']?.map((e) => SuperHero(
            int.parse(e['id']),
            name:        e['name'],
            powerstats:  e['powerstats']  ?? ({}),
            biography:   e['biography']   ?? ({}),
            appearance:  e['appearance']  ?? ({}),
            connections: e['connections'] ?? ({}),
            work:        e['work']        ?? ({}),
            url:         e['image']['url']
        )));
        
        _isLoading = false;

      }).catchError((e) {
        _error = true;
      });
    }
    notifyListeners();
  }

}
