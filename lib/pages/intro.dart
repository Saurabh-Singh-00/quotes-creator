import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/user/user_bloc.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Welcome to Creator!",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Lobster',
              fontSize: 28.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.hdr_strong,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "- Imagination is the power of the mind over the possibilities of things.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontStyle: FontStyle.italic,
              fontSize: 16.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            "Swipe left to get started",
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ),
      ],
    );
  }
}

class SetUserPreferencePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "We are almost done!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontFamily: 'Lobster',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    gapPadding: 12.0,
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Your name here",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "We never share your name or any other information to any third party vendors, all your data is saved on your device itself. We care about your data",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  fontSize: 12.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    elevation: .0,
                    padding: EdgeInsets.all(16.0),
                    child: (state is SavingUserPreference)
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            "Get started",
                            style: TextStyle(fontSize: 18.0),
                          ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    onPressed: () {
                      if (controller.value.text
                          .trimRight()
                          .trimLeft()
                          .isEmpty) {
                        Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text("Name is required to Proceed"),
                          ));
                      } else {
                        BlocProvider.of<UserBloc>(context)
                          ..add(SaveUserPreference(
                              username: controller.value.text));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AuthenticatedUser) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      child: Scaffold(
        body: PageView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            WelcomePage(),
            SetUserPreferencePage(),
          ],
          physics: BouncingScrollPhysics(),
          allowImplicitScrolling: true,
        ),
      ),
    );
  }
}
