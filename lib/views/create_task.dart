// imports nativos do flutter
import 'package:flutter/material.dart';

// import dos pacotes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_dropdown/find_dropdown.dart';

// import dos modelos
import 'package:desafio_esoft/core/models/anotations.dart';

class CreateTask extends StatefulWidget {

  final int? id;
  final String? title;
  final String? description;
  final bool? status;
  final int type;
  final int total;
  const CreateTask({ Key? key, required this.type, required this.total, this.id, this.title, this.description, this.status }) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {

  // Campos de texto
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  // variaveis da tela
  final CollectionReference _firestore = FirebaseFirestore.instance.collection("annotations");
  String _typeStatus = "";
  bool? _status;

  // inserir os campos
  _insertField() {
    _controllerTitle.text = widget.title!;
    _controllerDescription.text = widget.description!;
    _status = widget.status!;
    if ( widget.status == true ) {
      _typeStatus = "Ativa";
    } else {
      _typeStatus = "Finalizada";
    }
  }

  // validar campos
  _validateFields() {

    if ( _status == null ) {
      print("selecione um status");
    } else {

      var data = {
        "id": widget.total + 1,
        "title": _controllerTitle.text,
        "description": _controllerDescription.text,
        "status": _status,
        "created_at": DateTime.now().toString(),
        "updated_at": "null",
      };
      print("data create => $data");
      _firestore.add(data)
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("$error"));

    }
  }

  // validar os campos para atualizacao
  _validateUpdate() {

    if ( _status == null ) {
      print("selecione um status para a sua tarefa");
    } else {

      _firestore.where("id", isEqualTo: widget.id).get().then((snapshot) {

        var response = {
          "description": _controllerDescription.text,
          "status": widget.status,
          "updated_at": DateTime.now().toString(),
        };

        for ( var item in snapshot.docs ) {
          item.reference.update(response)
            .then((value) => Navigator.pop(context));
        }
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if ( widget.type == 1 ) {
      _insertField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ( widget.type == 0 )
          ? "Cadastrar tarefa"
          : "Editar tarefa",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric( vertical: 16, horizontal: 8 ),
        child: Column(
          children: [

            // titulo
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
              child: TextField(
                controller: _controllerTitle,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 20),
                enabled: ( widget.type == 0 )
                ? true
                : false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                  labelText: "Titulo",
                  filled: true,
                  errorText: ( _controllerTitle.text.trim().isNotEmpty )
                  ? null
                  : "A terefa precisa de um titulo",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // descricao
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
              child: TextField(
                controller: _controllerDescription,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                maxLines: 5,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(5, 16, 5, 16),
                  hintText: "Descrição",
                  filled: true,
                  errorText: ( _controllerDescription.text.trim().isNotEmpty )
                  ? null
                  : "A tarefa precisa de uma descrição",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // status
            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 16 ),
              child: FindDropdown(
                items: const [
                  "Ativa",
                  "Finalizada"
                ],
                label: "Status da tarefa",
                selectedItem: _typeStatus,
                showSearchBox: false,
                onChanged: ( type ) {

                  _typeStatus = type.toString();
                  if ( type == "Ativa" ) {
                    _status = true;
                  } else {
                    _status = false;
                  }
                },
                // faz a exibição da quantidade de tickets disponíveis
                dropdownBuilder: (context, type) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: ( _typeStatus.isEmpty )
                      ? const Text("Selecione um status")
                      : Text(_typeStatus),
                    ),
                  );
                },
                // controi a lista de tickets para seleção
                dropdownItemBuilder: (context, type, isSelected) {
                  return Container(
                    decoration: !isSelected
                    ? null
                    : BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      selected: isSelected,
                      title: Text( type.toString() ),
                    ),
                  );
                },
              ),
            ),

            // cadastrar
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Cadastrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if ( widget.type == 0 ) {
                    _validateFields();
                  } else {
                    _validateUpdate();
                  }
                },
              ),

            ),

          ],

        ),
      ),
    );
  }
}
