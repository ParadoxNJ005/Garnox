import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenPdf extends StatefulWidget {
  final String title;
  final String link;
  const OpenPdf({super.key, required this.link, required this.title});

  @override
  State<OpenPdf> createState() => _OpenPdfState();
}

class _OpenPdfState extends State<OpenPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.link,
        key: _pdfViewerKey,
      ),
    );
  }
}