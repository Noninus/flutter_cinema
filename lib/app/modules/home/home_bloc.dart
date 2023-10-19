import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cinema/app/shared/movie_response.dart';
import 'package:flutter_cinema/app/shared/response_state.dart';

class HomeBloc extends BlocBase {
  HomeBloc() : super(null);

  final StreamController<ResponseState> moviesController = StreamController();

  Stream<ResponseState> get moviesStream => moviesController.stream;

  void changeMoviesStatus(ResponseState state) {
    if (!moviesController.isClosed) {
      moviesController.sink.add(state);
    }
  }

  getMovies() async {
    changeMoviesStatus(ResponseState(status: Status.LOADING));

    Response response = await Dio().get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {'language': 'pt-BR'},
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMTBkNTVjNjdjYTg2NTI3YTdjY2Q0ODJmMDg3MmFiMiIsInN1YiI6IjVjZDE5MzU5MGUwYTI2MDk4MTAzMjdmYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0Ht5N50c4QTd6strCgZ_vRcMee0iXXBxMrZbFma-bo0'
        },
      ),
    );

    if (response.statusCode == 200) {
      MovieResponse movies = MovieResponse.fromJson(response.data);
      changeMoviesStatus(ResponseState(status: Status.SUCCESS, data: movies));
    } else {
      changeMoviesStatus(ResponseState(status: Status.ERROR));
    }
  }
}
