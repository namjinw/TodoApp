import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/model/to_do.dart';
import 'package:dart_my/page/detail.dart';
import 'package:dart_my/util/color.dart';
import 'package:dart_my/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayListDialog extends StatefulWidget {
  final DateTime date;

  const DayListDialog({super.key, required this.date});

  @override
  State<DayListDialog> createState() => _DayListDialogState();
}

class _DayListDialogState extends State<DayListDialog> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ToDoController.todos,
      builder: (context, value, child) => Dialog(
        shape: ShapedInputBorder(
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        ),
        backgroundColor: neutral,
        insetPadding: .symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: .min,
          children: [
            const SizedBox(height: 20),
            Text(
              '${DateFormat('y년 M월 d일').format(widget.date)}',
              style: TextStyle(fontSize: 24, fontWeight: .bold),
            ),
            const SizedBox(height: 30),
            todoItems(value),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget todoItems(List<ToDo> todos) {
    final todayTodo = ToDoController.todos.value
        .where(
          (e) =>
              e.date.year == widget.date.year &&
              e.date.month == widget.date.month &&
              e.date.day == widget.date.day,
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          spacing: 12,
          children: .generate(
            todayTodo.length,
            (index) => todoCard(todayTodo[index]),
          ),
        ),
      ),
    );
  }

  Widget todoCard(ToDo t) => GestureDetector(
    onTap: () {
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => DetailPage(todo: t)),
      );
    },
    child: Container(
      padding: .all(12),
      decoration: BoxDecoration(
        color: action,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 6,
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 15,
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: t.color,
                  borderRadius: .circular(3),
                ),
              ),
              Expanded(
                child: Text(
                  t.title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: .bold),
                ),
              ),
            ],
          ),
          if (t.tag.isNotEmpty)
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: .horizontal,
              child: Row(
                spacing: 10,
                children: .generate(
                  t.tag.length,
                  (index) => Container(
                    padding: .symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: .circular(4),
                    ),
                    child: Text(
                      t.tag[index],
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
          Container(
            width: sizew(context),
            padding: .all(10),
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: .circular(10),
            ),
            child: Text(t.content, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}
