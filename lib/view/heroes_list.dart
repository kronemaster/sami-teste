import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sami/model/model.dart';
import 'package:sami/view/hero_details.dart';
import 'package:sami/controller/state.dart';

class HeroesList extends StatelessWidget {
  const HeroesList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// O [Consumer] é um widget do pacote [provider] que atualiza seus descendentes
    /// a cada notificação que ouve do [ChangeNotifier]. A alternativa é definir algo do tipo:
    /// final ListNotifier _prov = Provider.of<ListNotifier>(context); // --> só que agora com listen: true
    /// O que gera a necessidade de _prov.dispose() para evitar memory leak. O [Consumer] por sua vez já cuida disso.
    return Consumer<ListNotifier>(
      /// Neste caso definir um [child] não seria muito útil
      /// porque a variável em questão está na ponta da árvore.
      
      builder: (context, prov, child) => prov.heroes.isEmpty
      /// Erro ou carregando
      ? SliverFillRemaining(child: Center(child: prov.error ? const Text('HOUVE UM ERRO COM A CONEXÃO') : const CircularProgressIndicator())) 
      
      : SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {

            /// Usado para paginação. Cada vez que o usuário o aperta o botão
            /// a lista de heróis é acrescida de [kQueryLimit = 8] novos heróis.
            if(index >= prov.heroes.length) {
              
              /// Se a lista for produto de uma [search] não tem porque paginar.
              return prov.searchFilled ? Container() : Padding(
                padding: const EdgeInsets.all(8.0),
                child: prov.isLoading ? const Center(child: CircularProgressIndicator()) : IconButton(
                  icon: const Icon(Icons.add),
                  /// O método .fill() também poderia ser convocado sem o listener, mas
                  /// como estamos dentro do [Consumer], é conveniente usar o objeto dado.
                  onPressed: () => prov.fill(paginate: true), 
                ),
              );
            }
            
            /// A lista de heróis é definida pelas alterações no [ChangeNotifier], por isso 
            /// o elemento [thisHero] é definido a partir de -->prov<--.heroes.
            SuperHero thisHero = prov.heroes[index];
          
            return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => HeroDetails(thisHero))),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),

                        /// Como se trata de super-heróis achei conveniente
                        /// usar uma animação [Hero] para a transição.
                        child: Hero(
                          tag: thisHero.id,
                          child: CircleAvatar(
                            radius: 48,
                            foregroundImage: thisHero.url != '' ? Image.network(thisHero.url).image : null,
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(thisHero.name),
                        subtitle: Text('${thisHero.biography?['full-name'] ?? ''}\n${thisHero.biography?['alignment'] == 'bad' ? 'VILÃO' : 'HERÓI'}'),
                      )
                    )
                  ],
                ),
              ),
            );
          },
          /// Comprimento da lista + 1,
          /// por causa do botão de paginação. (+)
          childCount: prov.heroes.length + 1,
        ),
      ),
    );
  }
}