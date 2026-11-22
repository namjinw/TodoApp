import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/model/to_do.dart';
import 'package:dart_my/util/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util/util.dart';

class DetailPage extends StatefulWidget {
  final ToDo todo;

  const DetailPage({super.key, required this.todo});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: neutral,
      body: content(),
    );
  }

  Widget content() => SingleChildScrollView(
    padding: .symmetric(vertical: 30, horizontal: 20),
    physics: BouncingScrollPhysics(),
    child: Container(
      padding: .all(20),
      decoration: BoxDecoration(color: action, borderRadius: .circular(12)),
      child: Column(
        spacing: 20,
        crossAxisAlignment: .start,
        children: [
          title(),
          if (widget.todo.tag.isNotEmpty) tagList(),
          todoContent(),
        ],
      ),
    ),
  );

  Widget todoContent() => Column(
    spacing: 15,
    crossAxisAlignment: .start,
    children: [
      Text('할일 내용', style: TextStyle(fontSize: 20, fontWeight: .bold)),
      Container(
        width: sizew(context),
        padding: .all(10),
        decoration: BoxDecoration(color: primary, borderRadius: .circular(4)),
        child: Text(
          widget.todo.content,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: .bold,
          ),
        ),
      ),
    ],
  );

  Widget tagList() => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    scrollDirection: .horizontal,
    child: Align(
      child: Row(
        spacing: 10,
        children: .generate(
          widget.todo.tag.length,
          (index) => Container(
            padding: .symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: .circular(4),
            ),
            child: Text(
              widget.todo.tag[index],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: .bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget title() => Row(
    spacing: 15,
    children: [
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: widget.todo.color,
          borderRadius: .circular(3),
        ),
      ),
      Expanded(
        child: Text(
          widget.todo.title,
          maxLines: 1,
          overflow: .ellipsis,
          style: TextStyle(fontSize: 24, fontWeight: .bold),
        ),
      ),
    ],
  );

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    centerTitle: true,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Icon(Icons.arrow_back),
    ),
    title: Text(
      '${DateFormat('y년 M월 d일').format(widget.todo.date)}',
      style: TextStyle(fontSize: 32, fontWeight: .bold),
    ),
  );
}
