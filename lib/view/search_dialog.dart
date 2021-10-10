
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sami/controller/state.dart';

/// Para permitir que o usuário cancele a pesquisa por poderes (x)
class PowerSearchButton extends StatefulWidget {
  const PowerSearchButton(this.context, { Key? key }) : super(key: key);
  /// O contexto aqui é necessário pois para recrutar o Provider.of(context)
  /// é necessário que seja o mesmo contexto do [ChangeNotifierProvider]. 
  final BuildContext context;

  @override
  _PowerSearchButtonState createState() => _PowerSearchButtonState();
}

/// Para definir o Dialog da pesquisa avançada (por poderes)
class _PowerSearchButtonState extends State<PowerSearchButton> {

  bool _searchingPowers = false;
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _searchingPowers ? const Icon(Icons.close) : const Icon(Icons.filter_alt_outlined),
      onPressed: () {
        if(_searchingPowers) {

          /// Provider sendo recrutado sem o listener, apenas para acionar os métodos
          final ListNotifier _provider = Provider.of<ListNotifier>(widget.context, listen: false);
          
          /// Limpando as variáveis de pesquisa
          _provider.setVariables();
          /// Reconstruindo a lista já com as variáveis limpas
          _provider.fill();

          setState(() => _searchingPowers = false);
        } else {
          showDialog(
            context: context, 
            builder: (BuildContext context) => SearchDialog(this.context)
          ).then((value) => setState(() => _searchingPowers = true));
        } 
      }
    );
  }
}

class SearchDialog extends StatefulWidget {
  const SearchDialog(this.context, { Key? key }) : super(key: key);
  final BuildContext context;

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  
  bool _searching = false;

  String? _searchBy = 'intelligence';
  double _sliderValue = 0;
  bool _greaterThan = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pesquisa avançada', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.only(right: 4),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text('PODER:')),
                Flexible(child: DropdownButton<String>(
                  value: _searchBy,
                  onChanged: (v) => setState(() => _searchBy = v),
                  items: [
                    'intelligence',
                    'strength',
                    'speed',
                    'durability',
                    'power',
                    'combat',
                  ].map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList()
                )),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: DropdownButton<String>(
                  underline: Container(),
                  value: _greaterThan == true ? 'MAIOR QUE' : 'MENOR QUE',
                  onChanged: (v) => setState(() => _greaterThan = v == 'MAIOR QUE'),
                  items: [
                    'MAIOR QUE',
                    'MENOR QUE',
                  ].map((e) => DropdownMenuItem<String>(child: Text(e), value: e)).toList()
                )),
                Flexible(child: Text(_sliderValue.round().toString())),
              ],
            ),
          ),
          Slider(value: _sliderValue, max: 100, onChanged: (v) => setState(() => _sliderValue = v)),
          _searching ? const CircularProgressIndicator() : Container(height: 36)
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCELAR', style: Theme.of(context).textTheme.subtitle2)
        ),
        TextButton(
          onPressed: () {
            setState(() => _searching = true);

            /// Provider sendo recrutado sem o listener, apenas para acionar os métodos
            final ListNotifier _provider = Provider.of<ListNotifier>(widget.context, listen: false);

            /// Definindo as variáveis de pesquisa
            _provider.setVariables(
              searchBy: _searchBy, 
              greaterThan: _greaterThan, 
              value: (_sliderValue).round()
            );
            /// Convocando o método já com as variáveis definidas
            _provider.fill().then((b) => Navigator.pop(context, b));

          }, 
          style: ElevatedButton.styleFrom().copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
          child: Text('PROCURAR', style: Theme.of(context).textTheme.apply(bodyColor: Colors.white).subtitle2)
        ),
      ],
    );
  }
}
