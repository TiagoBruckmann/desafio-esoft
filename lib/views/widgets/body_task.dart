// imports nativos do flutter
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_esoft/blocs/anotations.bloc.dart';
import 'package:desafio_esoft/views/widgets/message_widget.dart';
import 'package:desafio_esoft/views/widgets/refresh/refresh_widget.dart';
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
  final AnnotationBloc _bloc = AnnotationBloc();

  // buscar as anotacoes
  _getData() async {

    _bloc.clear();
    var data;
    if ( widget.status == 1 ) {
      data = await _firestore.where("status", isEqualTo: 1 ).get();
    } else {
      data = await _firestore.where("status", isEqualTo: 0 ).get();
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
      _bloc.add(modelAnnotations);
    }

  }

  FutureOr _onGoBack(dynamic value) {
    _getData();
  }

  // cadastrar nova tarefa
  _goToNew() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTask(total: _bloc.listAnnotations.length, type: 0,),
      ),
    ).then(_onGoBack);
  }

  // alterar o status da anotacao
  _changeStatus( ModelAnnotations data ) {

    return showDialog(
        context: context,
        builder: (contex) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 200, 16, 0),
            child: Center(
              child: Column(
                children: [
                  AlertDialog(
                    title: const Text(
                      "Gostaria mesmo de alterar o status da tarefa?",
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      ( data.status == 1 )
                      ? "Ao Confirmar a tarefa sairá da sua listagem principal e será exibida na listagem de tarefas finalizadas."
                      : "Ao Confirmar a tarefa sairá da sua listagem de tarefas finalizadas e será exibida na listagem de tarefas pendentes.",
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {

                          Navigator.pop( context );

                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {

                          Navigator.pop(
                            context,
                            _confirmChange( data ),
                          );

                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _confirmChange( ModelAnnotations data ) {

    _firestore.where("id", isEqualTo: data.id).get().then((snapshot) {

      int status;
      if ( data.status == 1 ) {
        status = 0;
      } else {
        status = 1;
      }
      var response = {
        "status": status,
        "updated_at": DateTime.now().toString(),
      };

      for ( var item in snapshot.docs ) {
        item.reference.update(response);
        _bloc.delete(data);
        CustomSnackBar(context, "Status atualizado com sucesso", Colors.green);
      }
    });

  }

  // ir para a edicao da anotacao
  _goToEdit( ModelAnnotations data ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTask(
          total: _bloc.listAnnotations.length,
          type: 1,
          id: data.id,
          title: data.title,
          description: data.description,
          status: data.status,
        ),
      ),
    ).then(_onGoBack);

  }

  // deletar uma anotacao
  _trash( ModelAnnotations data ) {

    return showDialog(
        context: context,
        builder: (contex) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 200, 16, 0),
            child: Center(
              child: Column(
                children: [
                  AlertDialog(
                    title: const Text(
                      "Gostaria mesmo de deletar esta tarefa?",
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      "Ao Confirmar a tarefa será completamente removida e a ação não poderá ser desfeita.",
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop( context );
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                        onPressed: () {

                          Navigator.pop(
                            context,
                            _confirmTrash( data ),
                          );

                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  // confirmar a exclusao da tarefa
  _confirmTrash( ModelAnnotations data ) {

    _firestore.where("id", isEqualTo: data.id).get().then((snapshot) {

      for ( var item in snapshot.docs ) {
        item.reference.delete();
        _bloc.delete(data);
        CustomSnackBar(context, "Tarefa removida com sucesso", Colors.green);
      }
    });

  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.closeStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<List>(
        stream: _bloc.listenAnnotations,
        builder: ( context, snapshot ) {

          if ( snapshot.hasError ) {

            return const RefreshWidget(message: "Nenhuma tarefa foi encontrada");

          } else if ( _bloc.listAnnotations.isEmpty ) {

            return const RefreshWidget(message: "Nenhuma tarefa foi encontrada");

          } else {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _bloc.listAnnotations.length,
              itemBuilder: ( context, index ) {

                ModelAnnotations modelAnnotations = _bloc.listAnnotations[index];

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
            );
          }
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
