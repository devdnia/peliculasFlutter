import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';


class MoviesProvider extends ChangeNotifier{

  String _apiKey   = '75cba12db511fa30707afdabee60304a';
  String _baseUrl  = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int , List<Cast>> moviesCast ={};

  int _popularPage = 0 ;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );


  final StreamController<List<Movie>> _suggestionsStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionsStreamController.stream;

  MoviesProvider(){
    print('MoviesProvider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

Future<String> _getJsonData( String endopint, [ int page=1 ]) async{
  final url =
      Uri.https( _baseUrl, endopint, {
        'api_key'   : _apiKey,
        'language'  : _language, 
        'page'      : '$page'
        });

      final response = await http.get(url);
      return response.body;
}
  // Para el Swiper
  getOnDisplayMovies() async{
    
      final jsonData = await this._getJsonData('3/movie/now_playing');
      final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);


      this.onDisplayMovies = nowPlayingResponse.results;

      //Escucha los cambios de los datos
      notifyListeners();
  }

  getPopularMovies() async{

      _popularPage++;

      final jsonData = await this._getJsonData( '3/movie/popular' , _popularPage );

      final popularResponse = PopularResponse.fromJson(jsonData);

      // Destructurado
      this.popularMovies = [ ...popularMovies, ...popularResponse.results];

      //Escucha los cambios de los datos
      notifyListeners();
  }

  Future<List<Cast>> getMovieCast ( int movieId) async {

    // Evalua si tiene info y la envia.
    if ( moviesCast.containsKey( movieId )) return moviesCast[ movieId ]!;
  
    final jsonData = await this._getJsonData( '3/movie/$movieId/credits' );
    final creditsReponse = CreditsResponse.fromJson( jsonData );

    moviesCast[movieId] = creditsReponse.cast;

    return creditsReponse.cast;

  }

  Future<List<Movie>> searchMovies(String query ) async {

  final url =
      Uri.https( _baseUrl, '3/search/movie', {
        'api_key'   : _apiKey,
        'language'  : _language, 
        'query'     : query
        });


      final response = await http.get(url);
      final searchResponse = SearchResponse.fromJson( response.body );
  
     return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm){
    debouncer.value = '';
    debouncer.onValue = ( value ) async{
      //print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies( value );
      this._suggestionsStreamController.add( results );
    };

    final timer = Timer.periodic(Duration( milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration( milliseconds: 301)).then(( _) => timer.cancel());
  }
  

}