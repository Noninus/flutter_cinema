import 'package:flutter/material.dart';
import 'package:flutter_cinema/app/modules/home/home_bloc.dart';
import 'package:flutter_cinema/app/shared/movie_response.dart';
import 'package:flutter_cinema/app/shared/response_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeBloc = Modular.get<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmes Populares"),
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              homeBloc.getMovies();
            },
            child: Text("carregar filmes")),
        Expanded(
          child: StreamBuilder(
            stream: homeBloc.moviesStream,
            builder:
                (BuildContext context, AsyncSnapshot<ResponseState> snapshot) {
              switch (snapshot.data?.status) {
                case Status.LOADING:
                  return Center(child: CircularProgressIndicator());
                case Status.SUCCESS:
                  MovieResponse movieResponse = snapshot.data?.data;
                  List<Results> results = movieResponse.results!;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index) {
                      Results r = results[index];
                      return ListTile(
                          leading: Image.network(
                              'https://image.tmdb.org/t/p/w500${r.posterPath}'),
                          title: Text(r.title!));
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
        )
      ]),
    );
  }
}
