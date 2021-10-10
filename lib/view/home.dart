import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sami/main.dart';
import 'package:sami/view/heroes_list.dart';
import 'package:sami/view/state.dart';
import 'package:sami/view/widgets/search_bar.dart';
import 'package:sami/view/widgets/search_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState(){
    /// Para preencher a lista inicialmente, é preciso que o [Provider]
    /// tenha um [context] sobre o qual poderá atuar. Esta chamada serve
    /// para convocar o método fill() assim que o último frame seja construído. 
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<ListNotifier>(context, listen: false).fill();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          
          /// Para busca avançada (poderes)
          PowerSearchButton(this.context)  // [this.context] porque precisa do contexto do [ChangeNotifierProvider]
          
        ],
      ),
      body: const CustomScrollView(
        slivers: [

          /// Campo de pesquisa
          SearchBar(),
          
          /// Lista de heróis
          HeroesList()

        ],
      ),
      
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Text(kAuthorName.substring(0,1), textScaleFactor: 2)
            ),
            accountName:  const Text(kAuthorName), 
            accountEmail: const Text(kAuthorEmail)
          ),
          Expanded(child: Container()),
          Text('v1.0', textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption),
          const SizedBox(height: 16)
        ],
      )
    );
  }
}
