import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_bloc.dart';
import 'package:insta_creator/blocs/photo/photo_bloc.dart';
import 'package:insta_creator/models/photo.dart';
import 'package:insta_creator/services/storage.dart';
import 'package:insta_creator/widgets/draggable_text.dart';
import 'package:insta_creator/widgets/image_loader.dart';
import 'package:insta_creator/widgets/model_text_input.dart';
import 'dart:ui' as ui;

class PhotoEditPage extends StatefulWidget {
  final Photo photo;

  const PhotoEditPage({Key key, this.photo}) : super(key: key);

  @override
  _PhotoEditPageState createState() => _PhotoEditPageState();
}

class _PhotoEditPageState extends State<PhotoEditPage> {
  EditBloc editBloc;
  GlobalKey _canvasKey = GlobalKey();
  double filterOpacity = 0.0;
  Color filterColor = Colors.black;
  bool showTextInput = false;
  bool showFilterOpacitySlider = false;

  final Map<String, Map<String, dynamic>> navbarItems = {
    "Change Filter": {
      "icon": Icons.photo_filter,
      "callback": (BuildContext context, EditBloc bloc) {},
    },
    "Filter Opacity": {
      "icon": Icons.opacity,
      "callback": (BuildContext context, EditBloc bloc) {},
    },
    "Write": {
      "icon": Icons.text_fields,
      "callback": (BuildContext context, EditBloc bloc) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return ModalTextInput(
              bloc: bloc,
              isEdit: false,
            );
          },
        );
      },
    },
  };

  @override
  void initState() {
    editBloc = EditBloc(background: widget.photo);
    super.initState();
  }

  @override
  void dispose() {
    editBloc.close();
    super.dispose();
  }

  void changeColorFilter() {
    setState(() {
      filterColor = Colors.accents[Random().nextInt(Colors.accents.length)];
    });
  }

  void changeFilterOpacity() {
    setState(() {
      filterOpacity = (filterOpacity + 0.1) % 1.0;
    });
  }

  Future<String> saveImage() async {
    RenderRepaintBoundary boundary =
        _canvasKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    String path = await Storage.saveImage(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    BlocProvider.of<PhotoBloc>(context).repository.addPhotoToSavedList(path);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: .0,
        actions: <Widget>[
          StreamBuilder<bool>(
            initialData: false,
            stream: editBloc.savingStream.stream,
            builder: (context, snapshot) {
              return FlatButton(
                onPressed: !snapshot.data
                    ? () async {
                        editBloc.add(Save());
                        await saveImage();
                        editBloc.add(Saved());
                      }
                    : () {},
                child: Text(
                  snapshot.data ? "Saving" : "Save",
                ),
                color: Colors.black,
                textColor: Colors.white,
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.photo.width / widget.photo.height,
          child: BlocConsumer<EditBloc, EditState>(
            listener: (context, state) {
              if (state is SaveComplete) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Saved"),
                    duration: Duration(seconds: 3),
                  ));
              }
            },
            buildWhen: (previousState, currentState) {
              return !(currentState is SaveComplete);
            },
            bloc: editBloc,
            builder: (context, state) {
              return RepaintBoundary(
                key: _canvasKey,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: <Widget>[
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            filterColor.withOpacity(filterOpacity),
                            BlendMode.darken,
                          ),
                          child: Image.network(
                            widget.photo.src != null
                                ? widget.photo.src.original
                                : widget.photo.srcFromDbOriginal,
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, progress) => Center(
                              child: ImageLoader(
                                child: child,
                                loadingProgress: progress,
                              ),
                            ),
                          ),
                        ),
                      ] +
                      ((state is Editing)
                          ? state.quotes.map((quote) {
                              return DraggableQuote(
                                quote: quote,
                                onDelete: () {
                                  editBloc.add(DeleteQuote(quote));
                                },
                                onEdit: () async {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => ModalTextInput(
                                      bloc: editBloc,
                                      quote: quote,
                                      isEdit: true,
                                    ),
                                  );
                                  setState(() {});
                                },
                              );
                            }).toList()
                          : []) +
                      [
                        Positioned(
                          right: 16.0,
                          top: 16.0,
                          child: Text(
                            "Photo by - ${widget.photo.photographer}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.0,
                              fontFamily: 'Lobster',
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16.0,
                          bottom: 16.0,
                          child: Icon(
                            Icons.hdr_strong,
                            color: Colors.white,
                          ),
                        ),
                      ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          bottomAppBarColor: Colors.black,
          canvasColor: Colors.black,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 0) {
              changeColorFilter();
            } else if (index == 1) {
              changeFilterOpacity();
            } else {
              (navbarItems.entries.toList()[index].value["callback"]
                  as Function)(context, editBloc);
            }
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: .0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: navbarItems.entries.map((element) {
            return BottomNavigationBarItem(
              icon: Icon(element.value["icon"]),
              title: Text(element.key),
            );
          }).toList(),
        ),
      ),
    );
  }
}
