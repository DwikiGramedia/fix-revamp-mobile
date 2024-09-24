import 'package:flutter/material.dart';
//import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';

class IRidiumReaderView extends StatefulWidget {
  final String path;
  const IRidiumReaderView({Key? key,required this.path}) : super(key: key);

  @override
  State<IRidiumReaderView> createState() => _IRidiumReaderViewState();
}

class _IRidiumReaderViewState extends State<IRidiumReaderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        alignment: Alignment.center,
        children: [
          //EpubScreen.fromPath(filePath:widget.path),
          Text("Chondro"),
        ],
      ),
    );
  }
}
