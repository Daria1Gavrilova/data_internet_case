import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Post> fetchPost(int postNumber) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postNumber'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class DataInternet extends StatefulWidget {
  const DataInternet({Key? key}) : super(key: key);

  @override
  _DataInternetState createState() => _DataInternetState();
}

class _DataInternetState extends State<DataInternet> {
  late Future<Post> futurePost;

  @override
  void initState(){
    super.initState();
    futurePost = fetchPost(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: const Text("Получение данных. Кейс 3.2"),
        ),
        body: Center(
          child: FutureBuilder<Post>(
              future: futurePost,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text('Заголовок: ${snapshot.data!.title}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 40),
                          Text('Основной текст: ${snapshot.data!.body}', style: TextStyle(fontSize: 20)),
                        ]
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              }
          ),
        ),
      ),
    );
  }
}
