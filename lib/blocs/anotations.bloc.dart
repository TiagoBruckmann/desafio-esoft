// imports nativos
import 'dart:async';

// import dos modelos
import 'package:desafio_esoft/core/models/annotations.dart';

class AnnotationBloc {

  final List<ModelAnnotations> _listAnnotations = [];
  List<ModelAnnotations> get listAnnotations => _listAnnotations;

  final _blocController = StreamController<List>();

  Stream<List> get listenAnnotations => _blocController.stream;

  clear() {

    _listAnnotations.clear();
    return _blocController.sink.add(listAnnotations);

  }

  void add( ModelAnnotations modelAnnotations ) {

    _listAnnotations.add(modelAnnotations);
    return _blocController.sink.add(listAnnotations);

  }

  void delete( ModelAnnotations modelAnnotations ) {

    _listAnnotations.removeWhere((e) => e.id == modelAnnotations.id);
    return _blocController.sink.add(listAnnotations);

  }

  closeStream() {
    _blocController.close();
  }
}