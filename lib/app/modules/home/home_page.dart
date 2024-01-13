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

  Future<void> _pullRefresh() async {
    homeBloc.getMovies();
  }

  @override
  void initState() {
    homeBloc.getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                  height: 50,
                  child: Center(
                      child: Text(
                    "Filmes Populares",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor),
                  ))),
              Expanded(
                child: StreamBuilder(
                  stream: homeBloc.moviesStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ResponseState> snapshot) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return const Center(child: CircularProgressIndicator());
                      case Status.SUCCESS:
                        MovieResponse movieResponse = snapshot.data?.data;
                        List<Results> results = movieResponse.results!;

                        return RefreshIndicator(
                            onRefresh: _pullRefresh,
                            child: GridView.count(
                              crossAxisCount: 3,
                              childAspectRatio:
                                  (464 / 696), // Explicar como isso funciona
                              children: List.generate(results.length, (index) {
                                Results r = results[index];
                                return Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: InkWell(
                                    onTap: () {
                                      Modular.to.pushNamed(
                                          '/${r.id}'); // Explicar por que passar só ID e não objeto inteiro
                                    },
                                    child: Hero(
                                      tag: "image${r.id}",
                                      child: Card(
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/original${r.posterPath}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ));

                      default:
                        return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
