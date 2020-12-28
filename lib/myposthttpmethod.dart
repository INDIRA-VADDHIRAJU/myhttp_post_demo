import 'dart:convert';

import 'package:http/http.dart ' as http;

import 'package:flutter/material.dart';

//this permission is to b added in android manifest file
//<uses-permission android:name="android.permission.INTERNET"/>

void main() {
  runApp(MainApppost());
}

class MainApppost extends StatefulWidget {
  //const MainApppost({Key key, this.futurecomments}) : super(key: key);

  @override
  _MainApppostState createState() => _MainApppostState();
}

class _MainApppostState extends State<MainApppost> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final bodycontroller = TextEditingController();
  Future<Webcomments> futurecomments;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('POST REQUEST DEMO'),
          backgroundColor: Colors.pink,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (futurecomments == null)
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: namecontroller,
                        decoration: InputDecoration(hintText: 'Enter name'),
                      ),
                      TextField(
                        controller: emailcontroller,
                        decoration: InputDecoration(hintText: 'Enter email'),
                      ),
                      TextField(
                        controller: bodycontroller,
                        decoration: InputDecoration(hintText: 'Enter body'),
                      ),
                      ElevatedButton(
                        child: Text('Create Data'),
                        onPressed: () {
                          setState(() {
                            futurecomments = createComments(namecontroller.text,
                                emailcontroller.text, bodycontroller.text);
                          });
                        },
                      ),
                    ],
                  ),
                )
              : FutureBuilder(
                  future: futurecomments,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data.name),
                          Text(snapshot.data.email),
                          Text(snapshot.data.body),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}

// class Mypostapp extends StatefulWidget {
//   final datacomments;

//   const Mypostapp({Key key, this.datacomments}) : super(key: key);
//   @override
//   _MypostappState createState() => _MypostappState();
// }

// class _MypostappState extends State<Mypostapp> {
//   final namecontroller = TextEditingController();
//   final emailcontroller = TextEditingController();
//   final bodycontroller = TextEditingController();

//   Future<Webcomments> futurecomments;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           TextFormField(
//             controller: namecontroller,
//             decoration: InputDecoration(hintText: 'enter name'),
//           ),
//           TextFormField(
//             controller: emailcontroller,
//             decoration: InputDecoration(hintText: 'enter email'),
//           ),
//           TextFormField(
//             controller: bodycontroller,
//             decoration: InputDecoration(hintText: 'enter body'),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   futurecomments = createComments(namecontroller.text,
//                       emailcontroller.text, bodycontroller.text);
//                 });
//               },
//               child: Text('create comment'))
//         ],
//       ),
//     );
//   }
// }

class Webcomments {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Webcomments({this.postId, this.id, this.name, this.email, this.body});
  factory Webcomments.fromJson(Map<String, dynamic> json) {
    return Webcomments(
        // postId: json['postId'] as int,
        // id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        body: json['body'] as String);
  }
}

Future<Webcomments> createComments(
    String name, String email, String body) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/comments',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'name': name, 'email': email, 'body': body}),
  );

  if (response.statusCode == 201) {
    print(jsonDecode(response.body));
    return Webcomments.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create comments');
  }
}
