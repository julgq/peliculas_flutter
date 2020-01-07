import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '58ba00614d0bb39959c23d3b1f508306';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 3;

  List<Pelicula> _populares = new List();

  // crear streamcontroller, que es como la tubería donde pasara la información
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  // creamos el sink que es como donde se inyectara información a la tubería
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  // creamos el stream que es el que entregara la información para mostrarla
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;



  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    // Uri nos permite crear una url con parametros.
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    return resp;
  }
}
