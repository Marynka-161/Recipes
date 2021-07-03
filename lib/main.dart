import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text('My Recipes'),
            backgroundColor: Colors.deepOrangeAccent,
            actions: <Widget>[
              IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {
                print("Click on upload button")
              },
            ),],

        ),
        body: RecipesListView(),
      ),
    );
  }
}

class Recipes{
  String picture;
  String name;
  String description;
  int id;

  Recipes({required this.picture, required this.name, required this.description, required this.id});

  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
        picture : json["picture"],
        name : json["name"],
        description : json["description"],
        id : json["id"]
    );
  }
}


class RecipesListView extends StatefulWidget {
  RecipesListViewWidget createState() => RecipesListViewWidget();
}

class RecipesListViewWidget extends State<RecipesListView> {
  final uri = Uri.parse("https://raw.githubusercontent.com/ababicheva/FlutterInternshipTestTask/main/recipes.json");

  Future<List<Recipes>> fetchFruits() async {

    final response = await http.get(uri);

    if (response.statusCode == 200) {

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Recipes> listOfRecipes = items.map<Recipes>((json) {
        return Recipes.fromJson(json);
      }).toList();
      listOfRecipes.sort((a, b) => a.id.compareTo(b.id));
      return listOfRecipes;
    }
    else {
      throw Exception('Failed to load data.');
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipes>>(
      future: fetchFruits(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator()
        );

        return ListView(
          padding : EdgeInsets.all(5),
          children : snapshot.data!
              .map((data) => ListTile(
            contentPadding : EdgeInsets.all(10),
            title: Text(data.name),
            leading : Image.network(data.picture, width: 100,
                height: 200, fit: BoxFit.fill, alignment: Alignment.center,),
            trailing: Text("${data.id}"),
            subtitle: Text(data.description)
          ))
              .toList(),
        );
      },
    );
  }
}