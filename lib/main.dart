import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/model/to_do.dart';
import 'package:dart_my/util.dart';
import 'package:flutter/material.dart';

Future<void> main() async {

  await ToDoController.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: fonts,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<ToDo> todos = ToDoController.todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() => SafeArea(
    child: Column(
      children: [
      ],
    ),
  );
}
