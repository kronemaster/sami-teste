
import 'package:flutter/material.dart';
import 'package:sami/model/model.dart';

/// Stateless pois se trata de uma página estática
class HeroDetails extends StatelessWidget {
  const HeroDetails(this.hero, { Key? key }) : super(key: key);
  
  final SuperHero hero;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hero.name)),
      body: ListView(
        children: [
          Hero(
            tag: hero.id,
            child: Image.network(hero.url),
          ),
          HeroSpecs('POWERSTATS' , hero.powerstats),
          HeroSpecs('BIOGRAPHY'  , hero.biography),
          HeroSpecs('APPEARANCE' , hero.appearance),
          HeroSpecs('CONNECTIONS', hero.connections),
          HeroSpecs('WORK'       , hero.work),
        ],
      ),
    );
  }
}

/// Para os detalhes do herói foi definida a [HeroSpecs]
/// que basicamente transforma um json (Map) numa disposição
/// de Rows que ligam os atributos aos valores. Nada de novo.
class HeroSpecs extends StatelessWidget {
  const HeroSpecs(this.title, this.data, { Key? key }) : super(key: key);
  final String title;
  final Map? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 8),
        Column(
          children: List.generate(data?.length ?? 0, (index) {
            
            final _key = data?.entries.toList()[index].key;
            final _val = data?.entries.toList()[index].value;
            
            return Container(
              margin: const EdgeInsets.all(18),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _key.toUpperCase(),
                  _val.toString()
                ].map((e) => Flexible(child: Text(e))).toList(),
              ),
            );
          })
        ),
        const SizedBox(height: 32)
      ],
    );
  }
}