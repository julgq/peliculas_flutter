import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  CardSwiper({@required this.peliculas});
  @override
  Widget build(BuildContext context) {
    // Usar MediaQuery para obtener los tamaños del dispositivo
    final _screenSize = MediaQuery.of(context).size;
    print(_screenSize.height);

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _screenSize.width * 0.7, // 70% de la pantalla
        itemHeight: _screenSize.height * 0.5, // 50% de la pantalla
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle',
                      arguments: peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(
                      peliculas[index].getPosterImg(),
                    ),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: peliculas.length,

        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}
