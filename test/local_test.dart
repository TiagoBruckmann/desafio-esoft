// imports nativos
import 'dart:convert' as convert;

// import dos pacotes
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart' as test_functions;

// import dos modelos
import 'package:desafio_esoft/core/models/anotations.dart';

void main() {

  test_functions.test('get documents ', () async {

    // var modelAnnotations = ModelAnnotations().getDocument();
    final dir = await getApplicationDocumentsDirectory();
    test_functions.equals("${dir.path}/anotations.json");

  });

  test_functions.test('save task ', () {

    var data = {
      "uid": 2712,
      "title": "Teste",
      "description": "Teste de salvamento local",
      "status": 0,
      "created_at": "2022-01-27 19:44:25.982",
      "updated_at": "null",
    };

    print("data => $data");

    ModelAnnotations().saveTask(data);

    test_functions.equals(true);

  });

  test_functions.test('read task ', () {

    List<ModelAnnotations> listTest = [];
    ModelAnnotations().readTasks().then((data) {
      print(data);
      listTest.addAll( convert.jsonDecode(data));
    });
    print("listTest => $listTest");

    test_functions.equals(listTest);

  });

  /*
  test_functions.test('Update task ', () {

    ModelAnnotations modelAnnotations = ModelAnnotations();
    modelAnnotations.uid = 2712;
    modelAnnotations.title = "teste";
    modelAnnotations.description = "Teste de conversão para dados do tipo MAP";
    modelAnnotations.status = 1;
    modelAnnotations.updatedAt = "2022-01-27 20:09:10.510";

    modelAnnotations.toMap();

    test_functions.equals(modelAnnotations);

  });

  test_functions.test('Delete task ', () {

    ModelAnnotations modelAnnotations = ModelAnnotations();
    modelAnnotations.uid = 2712;
    modelAnnotations.title = "teste";
    modelAnnotations.description = "Teste de conversão para dados do tipo MAP";
    modelAnnotations.status = 0;
    modelAnnotations.createdAt = "2022-01-27 19:44:25.982";
    modelAnnotations.updatedAt = "null";

    modelAnnotations.toMap();

    test_functions.equals(modelAnnotations);

  });
   */
}