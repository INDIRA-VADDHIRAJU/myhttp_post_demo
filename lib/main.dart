//this commented code below is AUTHENTICATION REQUEST CODE EXAMPLE
//is needed to include in all HTTP REQUEST while working with real server

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// Future<Webcomments> modifycomment(String body) async {
//   final http.Response response = await http.patch(
//     'https://jsonplaceholder.typicode.com/comments/1',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
// // THIS IS THE MAIN AUTHENTICATION REQUEST CODE BELOW //////
//       HttpHeaders.authorizationHeader:'Basic my_api_tokens_here'
//     },
//     body: jsonEncode(<String, String>{
//       'body': body,
//     }),
//   );

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart ' as http;

class Webcomments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Webcomments({this.postId, this.id, this.name, this.email, this.body});
  factory Webcomments.fromJson(Map<String, dynamic> json) {
    return Webcomments(
        postId: json['postId'] as int,
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        body: json['body'] as String);
  }
}

Future<Webcomments> modifycomment(String body) async {
  final http.Response response = await http.patch(
    'https://jsonplaceholder.typicode.com/comments/1',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      // which field want to change only that field to be given[here im changing only body]

      'body': body,
    }),
  );

  if (response.statusCode == 200) {
    print(response.statusCode);
    print(response.body);
    print(jsonDecode(response.body));
    return Webcomments.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load webcomments');
  }
}

Future<Webcomments> fetchcomments() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/comments/1');

  if (response.statusCode == 200) {
    print(response.statusCode);
    print(response.body);
    print(jsonDecode(response.body));

    return Webcomments.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load comments');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final bodycontroller = TextEditingController();

  Future<Webcomments> futurecomments;
  @override
  void initState() {
    futurecomments = fetchcomments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PATCH REQUEST DEMO'),
          backgroundColor: Colors.purpleAccent,
        ),
        body: FutureBuilder(
          future: futurecomments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'NAME :',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(snapshot.data.name),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'EMAIL :',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(snapshot.data.email),
                        ],
                      ),
                      Text(
                        'BODY :',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(snapshot.data.body),
                      TextFormField(
                        controller: bodycontroller,
                        decoration: InputDecoration(hintText: 'enter body'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              futurecomments =
                                  modifycomment(bodycontroller.text);
                            });
                          },
                          child: Text('Modify comment')),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
