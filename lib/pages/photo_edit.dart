import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_bloc.dart';
import 'package:insta_creator/blocs/photo/edit_state.dart';
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

  final Map<String, Map<String, dynamic>> navbarItems = {
    "Filter": {
      "icon": Icons.photo_filter,
      "callback": (BuildContext context, EditBloc bloc) {},
    },
    "Write": {
      "icon": Icons.text_fields,
      "callback": (BuildContext context, EditBloc bloc) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ModalTextInput(
              bloc: bloc,
            ),
          ),
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

  Future<bool> saveImage() async {
    RenderRepaintBoundary boundary =
        _canvasKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return await Storage.saveImage(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
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
          FlatButton.icon(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () async {
              /// TODO: Add Saving State
              await saveImage();
            },
            label: Text(
              "Save",
            ),
            color: Colors.black,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.photo.width / widget.photo.height,
          child: BlocBuilder<EditBloc, EditState>(
            bloc: editBloc,
            builder: (context, state) {
              return RepaintBoundary(
                key: _canvasKey,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: <Widget>[
                        Image.network(
                          widget.photo.src.original,
                          fit: BoxFit.contain,
                          loadingBuilder: (_, child, progress) => Center(
                            child: ImageLoader(
                              child: child,
                              loadingProgress: progress,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black38,
                          ),
                        ),
                      ] +
                      ((state is Editing)
                          ? state.quotes.map((quote) {
                              return DraggableQuote(
                                quote: quote,
                              );
                            }).toList()
                          : []),
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
            (navbarItems.entries.toList()[index].value["callback"] as Function)(
                context, editBloc);
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
