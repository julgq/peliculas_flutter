import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = new PeliculasProvider();

  final peliculas = ['Spiderman', 'Auaman', 'SuperMan', 'Capitan'];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America',
  ];

  String seleccion = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // Acciones de nuestro AppBar

    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            // Limpiar el input
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // Icono a la izquierda del AppBar

    return IconButton(
        onPressed: () {
          print('Leading Icon Press');
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // Builder que crea los resultados que vamos a mostrar.
    return Center(
        child: Container(
      height: 100.0,
      color: Colors.blueAccent,
      child: Text(seleccion),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.contain,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    // cerrar la busqueda
                    close(context, null);
                    pelicula.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle',
                        arguments: pelicula);
                  });
            }).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    /*
    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    // TODO: implement buildSuggestions
    // Sugerencias que aparecen cuando la persona escribe
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  }*/
  }
}
