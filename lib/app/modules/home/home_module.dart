import 'package:flutter_cinema/app/modules/home/home_bloc.dart';
import 'package:flutter_cinema/app/modules/home/home_page.dart';
import 'package:flutter_cinema/app/modules/home/movie_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.add(HomeBloc.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
    r.child('/:id', child: (context) => MoviePage(id: r.args.params['id']));
  }
}
