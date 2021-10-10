import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sami/controller/state.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final TextEditingController controller = TextEditingController();

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// Provider sendo recrutado sem o listener, apenas para convocar o método .search()
    final ListNotifier _provider = Provider.of<ListNotifier>(context, listen: false);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      toolbarHeight: 70,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: TextField(
            controller: controller,
            onSubmitted: (String val) {
              _provider.search(val);
            },
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Pesquisar',

              /// Caso o usuário queira cancelar a pesquisa, adiciona-se o [IconButton] (x) para limpar o campo.
              /// E faz-se uso de um [Consumer] pois isso implica em uma alteração de estado do suffixIcon.
              /// Vale lembrar também que a alteração de estado deve ser feita o mais localizada possível.
              suffixIcon: Consumer<ListNotifier>(
                /// Aqui sim faz sentido o uso do [child], que
                /// fica abaixo da alteração na árvore mas não 
                /// sofre mudanças de estado.
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear(); // Não fosse pelo controller esse widget poderia ser todo stless
                    _provider.search(null);
                  } 
                ),
                builder: (context, prov, child) => !prov.searchFilled ? const Icon(Icons.search) : child!
              ) 
            ),
          ),
        ),
      ),
    );
  }
}
