import 'dart:convert';

import 'package:buscador_gif/screens/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  static String id = "home";

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _search;
  int _offSet = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
        Uri.https(
          "api.giphy.com",
          "/v1/gifs/trending",
          {
            "api_key": "WBEnnvpaXXQWxxvMigmXUH9JQXIWwAb5",
            "limit": "20",
          },
        ),
      );
    } else if (_search == "" || _search!.isEmpty) {
      response = await http.get(
        Uri.https(
          "api.giphy.com",
          "/v1/gifs/trending",
          {
            "api_key": "WBEnnvpaXXQWxxvMigmXUH9JQXIWwAb5",
            "limit": "20",
          },
        ),
      );
    } else {
      response = await http.get(
        Uri.https(
          "api.giphy.com",
          "/v1/gifs/search",
          {
            "api_key": "WBEnnvpaXXQWxxvMigmXUH9JQXIWwAb5",
            "q": _search,
            "limit": "19",
            "offset": _offSet.toString(),
            "rating": "g",
            "lang": "pt"
          },
        ),
      );
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    // _getGifs().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
          "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif",
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                label: Text("Pesquise Aqui!"),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hoverColor: Colors.white,
                fillColor: Colors.white,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _offSet = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(
                    gifData: snapshot.data["data"][index],
                  ),
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.add, color: Colors.white, size: 70.0),
                Text(
                  "Carregar mais...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                )
              ],
            ),
            onTap: () {
              setState(() {
                _offSet += 19;
              });
            },
          );
        }
      },
    );
  }
}
