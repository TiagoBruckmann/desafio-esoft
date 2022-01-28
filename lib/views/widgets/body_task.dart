// imports nativos do flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import dos modelos
import 'package:desafio_esoft/core/models/anotations.dart';
import 'package:desafio_esoft/core/styles/app_colors.dart';

// import das telas
import 'package:desafio_esoft/views/create_task.dart';

class BodyTask extends StatefulWidget {

  final int status;
  const BodyTask({ Key? key, required this.status }) : super(key: key);

  @override
  _BodyTaskState createState() => _BodyTaskState();
}

class _BodyTaskState extends State<BodyTask> {

  // variaveis da tela
  final CollectionReference _firestore = FirebaseFirestore.instance.collection("annotations");
  final List<ModelAnnotations> _listAnnotations = [];

  _getData() async {

    setState(() {
      _listAnnotations.clear();
    });
    var data;
    if ( widget.status == 1 ) {
      data = await _firestore.where("status", isEqualTo: false ).get();
    } else {
      data = await _firestore.where("status", isEqualTo: true ).get();
    }

    for ( var item in data.docs ) {
      ModelAnnotations modelAnnotations = ModelAnnotations(
        id: item["id"],
        title: item["title"],
        description: item["description"],
        status: item["status"],
        createdAt: item["created_at"],
        updatedAt: item["updated_at"],
      );
      setState(() {
        _listAnnotations.add(modelAnnotations);
      });
    }

  }

  // cadastrar nova tarefa
  _goToNew() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTask(total: _listAnnotations.length, type: 0,),
      ),
    );
  }

  // alterar o status da anotacao
  _changeStatus( ModelAnnotations data ) {

    _firestore.where("id", isEqualTo: data.id).get().then((snapshot) {

      var response = {
        "status": !data.status,
        "updated_at": DateTime.now().toString(),
      };

      for ( var item in snapshot.docs ) {
        item.reference.update(response);
      }
    });

  }

  // ir para a edicao da anotacao
  _goToEdit( ModelAnnotations data ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTask(
          total: _listAnnotations.length,
          type: 1,
          id: data.id,
          title: data.title,
          description: data.description,
          status: data.status,
        ),
      ),
    );

  }

  // deletar uma anotacao
  _trash( ModelAnnotations data ) {

    _firestore.where("id", isEqualTo: data.id).get().then((snapshot) {

      for ( var item in snapshot.docs ) {
        item.reference.delete();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _listAnnotations.length,
        itemBuilder: ( context, index ) {

          ModelAnnotations modelAnnotations = _listAnnotations[index];

          return Padding(
            padding: const EdgeInsets.symmetric( horizontal: 16, vertical: 6 ),
            child: Card(
              color: AppColors.whiteSmoke,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // titulo e acoes
                  Padding(
                    padding: const EdgeInsets.only( top: 7 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only( left: 16 ),
                            child: Text(
                              "${modelAnnotations.title}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        Row(
                          children: [

                            // finalizar / ativar tarefa
                            Tooltip(
                              message: "Finalizar anotação",
                              child: GestureDetector(
                                onTap: () {
                                  _changeStatus( modelAnnotations );
                                },
                                child: const FaIcon(
                                  FontAwesomeIcons.checkCircle,
                                  color: Colors.green,
                                ),
                              ),
                            ),

                            // Editar tarefa
                            Padding(
                              padding: const EdgeInsets.symmetric( horizontal: 10 ),
                              child: Tooltip(
                                message: "Editar anotação",
                                child: GestureDetector(
                                  onTap: () {
                                    _goToEdit( modelAnnotations );
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.edit,
                                    color: AppColors.malibu,
                                  ),
                                ),
                              ),
                            ),

                            // deletar tarefa
                            Padding(
                              padding: const EdgeInsets.only( right: 16 ),
                              child: Tooltip(
                                message: "deletar anotação",
                                child: GestureDetector(
                                  onTap: () {
                                    _trash( modelAnnotations );
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: AppColors.darkGray,
                    indent: 16,
                    endIndent: 16,
                    thickness: 1,
                    height: 2,
                  ),

                  // descricao
                  Padding(
                    padding: const EdgeInsets.symmetric( horizontal: 16, vertical: 8 ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Flexible(
                          child: Text(
                            "${modelAnnotations.description}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          );

        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToNew();
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          color: AppColors.pxYellow,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),

    );
  }
}
