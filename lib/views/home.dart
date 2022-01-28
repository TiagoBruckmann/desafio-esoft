// imports nativos do flutter
import 'package:flutter/material.dart';

// import das telas
import 'package:desafio_esoft/views/widgets/body_task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  // exibir tabs na tela
  TabController ?_tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Desafio e-Soft"),

        bottom: TabBar(
          indicatorWeight: 4,
          isScrollable: true,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          indicatorColor: Theme.of(context).secondaryHeaderColor,
          tabs: const [

            Tab(
              child: Text("Abertos"),
            ),

            Tab(
              child: Text("Finalizados"),
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: const [

          // em aberto
          BodyTask( status: 1, ),

          // finalizados
          BodyTask( status: 0, ),

        ],
      ),

    );
  }
}
