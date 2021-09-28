import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {

  final int movieId;

  const CastingCards( {required this.movieId});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: ( _, AsyncSnapshot <List<Cast>>snapshot) {

        if ( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints( maxWidth: 150),
            height: 180.0,
            child: CupertinoActivityIndicator(),
          );
        }

        final cast = snapshot.data!;

        return Container(
          margin: EdgeInsets.only( bottom: 30.0 ),
          width: double.infinity,
          height: 180.0,
          child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: ( _, index) => _CastCard( actor: cast[index],),
      ),
    );
    
      },
    );


  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({required this.actor});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(actor.fullProfilePath),
              height: 140.0,
              width: 100.0,
              fit: BoxFit.cover,
              ),
          ),
          SizedBox(height: 5.0),
          Text(actor.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}