import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Webcomments> futurecomment;
  @override
  void initState() {
    super.initState();
    futurecomment = fetchcomments();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('DELETE REQUEST DEMO'),
            backgroundColor: Colors.teal,
          ),
          body: FutureBuilder(
            future: futurecomment,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // print(snapshot.data.title.toString());
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${snapshot.data?.name ?? 'Deleted'}'),
                        ),
                        Text('${snapshot.data?.email ?? 'Deleted'}'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${snapshot.data?.body ?? 'Deleted'}'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                futurecomment =
                                    deletecomments(snapshot.data.id.toString());
                              });
                            },
                            child: Text('Delete Data'))
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}

//https://jsonplaceholder.typicode.com/comments

//  "postId": 1,
//     "id": 1,
//     "name": "id labore ex et quam laborum",
//     "email": "Eliseo@gardner.biz",
//     "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"

class Webcomments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Webcomments({this.postId, this.id, this.name, this.email, this.body});
  factory Webcomments.fromJson(Map<String, dynamic> json) {
    return Webcomments(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}

Future<Webcomments> deletecomments(String id) async {
  final http.Response response = await http.delete(
    'https://jsonplaceholder.typicode.com/comments/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return Webcomments.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

Future<Webcomments> fetchcomments() async {
  //here change the id in url whichever id u want to delete(i changed to 4 )
  final response =
      await http.get('https://jsonplaceholder.typicode.com/comments/4');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Webcomments.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}
