import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/util/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final DateTime date;

  const DetailPage({super.key, required this.date});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), backgroundColor: neutral, body: content());
  }

  Widget content() => ValueListenableBuilder(
    valueListenable: ToDoController.todos,
    builder: (context, value, child) => Column(children: []),
  );

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back),
    ),
    title: Text(
      '${DateFormat('y년 M월 d일').format(widget.date)}',
      style: TextStyle(fontSize: 32, fontWeight: .bold),
    ),
  );
}
