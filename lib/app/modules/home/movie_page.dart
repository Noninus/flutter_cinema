import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cinema/app/modules/home/home_bloc.dart';
import 'package:flutter_cinema/app/shared/movie_detail.dart';
import 'package:flutter_cinema/app/shared/response_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MoviePage extends StatefulWidget {
  final String id;
  const MoviePage({super.key, required this.id});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final homeBloc = Modular.get<HomeBloc>();

  @override
  void initState() {
    homeBloc.getMovieDetail(widget.id);
    super.initState();
  }

  _starWidget(bool off) {
    return off
        ? const Icon(
            Icons.star,
            size: 40,
            color: Colors.grey,
          )
        : const Icon(
            Icons.star,
            size: 40,
            color: Colors.yellow,
          );
  }

  _ratingWidget(double voteAverage) {
    num startAmount = voteAverage / 2;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _starWidget(startAmount <= 1),
      _starWidget(startAmount <= 2),
      _starWidget(startAmount <= 3),
      _starWidget(startAmount <= 4),
      _starWidget(startAmount <= 5)
    ]);
  }

  Widget _success(MovieDetail movie) {
    num height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/original${movie.backdropPath}'),
                  fit: BoxFit.cover,
                ),
              ),
              //I blured the parent container to blur background image, you can get rid of this part
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  //you can change opacity with color here(I used black) for background.
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.2)),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                )),
            Column(
              children: [
                Container(
                  height: height * 0.1,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Hero(
                    tag: "image${movie.id}",
                    child: Card(
                      elevation: 18.0,
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        height: height * 0.4,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original${movie.posterPath}',
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
        SizedBox(
          height: height * 0.04,
        ),
        Expanded(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${movie.title}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "Data de Lançamento: ${movie.releaseDate}",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  _ratingWidget(movie.voteAverage!),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "Avaliada: ${movie.voteAverage}",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      "${movie.overview}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder(
            stream: homeBloc.movieDetailsStream,
            builder:
                (BuildContext context, AsyncSnapshot<ResponseState> snapshot) {
              switch (snapshot.data?.status) {
                case Status.LOADING:
                  return const Center(child: CircularProgressIndicator());
                case Status.SUCCESS:
                  MovieDetail movieResponse = snapshot.data?.data;

                  return _success(movieResponse);
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
