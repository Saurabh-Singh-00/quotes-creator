import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/blocs/photo/search_bloc.dart';
import 'package:insta_creator/blocs/user/user_bloc.dart';
import 'package:insta_creator/pages/home.dart';
import 'package:insta_creator/pages/intro.dart';
import 'package:insta_creator/pages/loading_auth.dart';
import 'package:insta_creator/repository/photo_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PhotoRepository photoRepository = PhotoRepository()..fetchFavouritePhotos();
  runApp(InstaCreator(
    photoRepository: photoRepository,
  ));
}

class InstaCreator extends StatelessWidget {
  final PhotoRepository photoRepository;

  const InstaCreator({Key key, this.photoRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoBloc>(
          create: (context) =>
              PhotoBloc(repository: photoRepository)..add(FetchPhotos()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc()..add(AuthenticateUser()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(repository: photoRepository),
        ),
      ],
      child: MaterialApp(
        title: "Insta Creator",
        debugShowCheckedModeBanner: false,
        home: LoadingAuthPage(),
        routes: {
          '/home': (_) => HomePage(),
          '/intro': (_) => IntroPage(),
        },
        theme: ThemeData(
          fontFamily: "DM Mono",
        ),
      ),
    );
  }
}
