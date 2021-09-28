import 'package:flutter/material.dart';

// Páginas
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';

//Providers
import 'package:peliculas/providers/movies_provider.dart';


 
void main() => runApp(AppState());

//Estado de la app
class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ( _ ) => MoviesProvider(), lazy: false,
          )
      ],
      child: MyApp(),
      );
  }
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home'    : ( _ ) => HomeScreen(),
        'details' : ( _ ) => DetailsScreen()
      },
      //Temas de la app
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.indigo
        )
      )

    );
  }
}
