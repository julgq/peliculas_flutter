import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePage;
  MovieHorizontal({@required this.peliculas, @required this.siguientePage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    // Este pagecontroller lo que hace identificar cuando el scroll se mueve
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200.0) {
        print('Cargar siguientes peliculas');
        siguientePage();
      } 
    });

    // TODO: implement build
    return Container(
      height: _screenSize.height * 0.27,
      child: PageView(
        pageSnapping: false,
        controller: _pageController,
        children: _tarjetas(context),
      ),
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(pelicula.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption),
          ],
        ),
      );
    }).toList();
  }
}
