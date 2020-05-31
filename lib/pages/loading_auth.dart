import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/user/user_bloc.dart';

class LoadingAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AuthenticatedUser) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
        if (state is UnauthenticatedUser) {
          Navigator.of(context).pushReplacementNamed('/intro');
        }
      },
      child: Material(
        child: Center(
          child: Text(
            "Loading Configurations..!",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
