import 'package:dart_my/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/to_do_controller.dart';
import '../model/to_do.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDo> todos = ToDoController.todos;
  DateTime selected = DateTime.now();
  DateTime now = DateTime.now();
  final PageController pageController = PageController(initialPage: 12);

  List<DateTime> getDate(DateTime d) {
    final first = DateTime(d.year, d.month, 1);
    final last = DateTime(d.year, d.month + 1, 0);
    final prev = first.weekday % 7;
    final next = 42 - (prev + last.day);

    List<DateTime> dates = [];

    List.generate(
      prev,
      (index) => dates.add(first.subtract(Duration(days: prev - index))),
    );
    List.generate(
      last.day,
      (index) => dates.add(DateTime(d.year, d.month, index + 1)),
    );
    List.generate(
      next,
      (index) => dates.add(DateTime(d.year, d.month + 1, index + 1)),
    );

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appBar(),
      body: content(),
    );
  }

  Widget content() => SafeArea(
    child: SingleChildScrollView(child: Column(children: [calender()])),
  );

  Widget calender() {
    final dates = getDate(now);

    return Column(
      children: [
        Text(
          style: TextStyle(fontWeight: .bold, fontSize: 32),
          '${now.year}, ${now.month}',
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(40),
          ),
          height: 350,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (value) {
              now = DateTime(now.year, now.month + (value - 12));
              setState(() {});
            },
            itemBuilder: (context, index) => GridView(
              padding: .symmetric(horizontal: 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              children: .generate(dates.length, (index) {
                final date = dates[index];
                return Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: date.month != now.month
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    leadingWidth: 100,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text('ToDo', style: TextStyle(fontWeight: .bold, fontSize: 24)),
    ),
  );
}
