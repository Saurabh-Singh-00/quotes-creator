import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/blocs/photo/search_bloc.dart';
import 'package:insta_creator/blocs/user/user_bloc.dart';
import 'package:insta_creator/pages/home.dart';
import 'package:insta_creator/pages/intro.dart';
import 'package:insta_creator/pages/loading_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(InstaCreator());
}

class InstaCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoBloc>(
          create: (context) => PhotoBloc()..add(FetchPhotos()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc()..add(AuthenticateUser()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(),
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
