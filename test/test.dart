// import dos pacotes
import 'package:desafio_esoft/blocs/anotations.bloc.dart';
import 'package:test/test.dart' as test_functions;

// import dos modelos
import 'package:desafio_esoft/core/models/annotations.dart';

void main() async {

  final AnnotationBloc _bloc = AnnotationBloc();

  test_functions.test('list annotations', () async {

    ModelAnnotations modelAnnotations = ModelAnnotations();
    modelAnnotations.id = 1;
    modelAnnotations.title = "Teste 1";
    modelAnnotations.description = "Teste da descrição";
    modelAnnotations.status = 1;
    modelAnnotations.createdAt = DateTime.now().toString();
    modelAnnotations.updatedAt = "null";
    modelAnnotations.toMap();
    _bloc.add(modelAnnotations);

    test_functions.equals(_bloc.listAnnotations);

  });

}