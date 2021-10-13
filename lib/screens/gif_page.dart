import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  static String id = "gif_page";
  const GifPage({
    Key? key,
    required this.gifData,
  }) : super(key: key);

  final Map gifData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(gifData["images"]["fixed_height"]["url"]);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          gifData["images"]["fixed_height"]["url"],
        ),
      ),
    );
  }
}
