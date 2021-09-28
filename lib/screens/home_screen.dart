import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context, 
              delegate: MovieSearchDelegate()),
            icon: Icon(Icons.search_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 5.0),
        child: Column(
          children: <Widget>[
            // Tarjetas principales
            CardSwiper( movies: moviesProvider.onDisplayMovies ),
            //Slider de peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      )
    );
  }
}