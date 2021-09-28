import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/casting_cards.dart';

class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    print(movie.title);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar( movie: movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle( movie: movie ),
              _Overview( movie: movie ),        
              CastingCards( movieId: movie.id )

              ])
            )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget{

  final Movie movie;

  const _CustomAppBar({ required this.movie });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only( bottom: 10.0),
          color: Colors.black12,
          child: Text(movie.title, style: TextStyle( fontSize: 16.0)
            )
          ),

        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'), 
          image: NetworkImage( movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget{

  final Movie movie;

  const _PosterAndTitle({required this.movie});
 
  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only( top: 20.0),
      padding: EdgeInsets.symmetric( horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPostImg),
                height: 150.0,
                ),
            ),
          ),
          
          SizedBox( width: 20 ),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 200.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( movie.title , style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2 ),
                
                Text( movie.originalTitle , style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 1 ),
          
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    SizedBox(width: 5.0,),
                    Text( '${movie.voteAverage}' , style: textTheme.caption)
                  ],
                )
              ],
            ),
          )
        ],
      )
      );
  }
}

class _Overview extends StatelessWidget{

  final Movie movie;

  const _Overview({required this.movie});

  @override
  Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric( horizontal: 30.0, vertical: 10.0),
    child: Text( movie.overview,
    textAlign: TextAlign.justify,
    style: Theme.of(context).textTheme.subtitle2),
  );
}
}