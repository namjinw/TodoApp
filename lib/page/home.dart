import 'package:dart_my/page/write.dart';
import 'package:dart_my/util/color.dart';
import 'package:dart_my/util/func.dart';
import 'package:dart_my/util/util.dart';
import 'package:flutter/cupertino.dart';
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
  late List<ToDo> todayTodo;

  DateTime selectedDate = DateTime.now(); // 선택된 날짜
  DateTime focusMonth = DateTime.now(); // 달력 날짜

  final PageController pageController = PageController(initialPage: 12);

  @override
  void initState() {
    super.initState();
    // 할일 날짜랑 오늘 날짜랑 비교해서 오늘 할일만 가져와 리스트로 만들기
    todayTodo = todos.where((t) => t.date == today).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral,
      appBar: appBar(),
      body: content(),
    );
  }

  Widget content() => SafeArea(
    child: SingleChildScrollView(
      padding: .symmetric(horizontal: 15),
      child: Column(
        spacing: 30,
        crossAxisAlignment: .start,
        children: [calendar(), todoItems()],
      ),
    ),
  );

  Widget todoItems() => Column(
    crossAxisAlignment: .start,
    children: [
      Text(
        '${DateFormat('M월 d일').format(today)}',
        style: TextStyle(fontSize: 32, fontWeight: .bold, color: primary),
      ),
      SizedBox(height: 12),
      Container(
        width: sizew(context),
        decoration: BoxDecoration(color: action, borderRadius: .circular(18)),
        padding: .symmetric(horizontal: 15, vertical: 20),
        child: todayTodo.isEmpty
            ? notItem()
            : Column(
                children: .generate(
                  todayTodo.length,
                  (index) => todoCard(todayTodo[index]),
                ),
              ),
      ),
    ],
  );

  Widget notItem() => Center(
    child: Column(
      children: [
        Icon(Icons.add_box, color: info, size: 50),
        Text(
          '오늘 등록된 할일이 없습니다',
          style: TextStyle(color: infoText, fontSize: 24),
        ),
        Text(
          '오늘 할 할일을 등록해보러 가요!',
          style: TextStyle(color: infoText.withAlpha(180), fontSize: 18),
        ),
      ],
    ),
  );

  Widget todoCard(ToDo item) => Container(
    decoration: BoxDecoration(color: item.color, borderRadius: .circular(12)),
    padding: .all(8),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontWeight: .bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        item.tag.isNotEmpty
            ? ListView.builder(
                scrollDirection: .horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: item.tag.length,
                itemBuilder: (context, index) => Container(
                  padding: .symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(6),
                  ),
                  child: Text(
                    item.tag[index],
                    style: TextStyle(fontWeight: .bold),
                  ),
                ),
              )
            : SizedBox(),
        Text(item.content),
      ],
    ),
  );

  Widget calendar() {
    final dates = getCalendarDays(focusMonth);

    return Column(
      children: [
        Text(
          style: TextStyle(fontWeight: .bold, fontSize: 32),
          '${focusMonth.year}, ${focusMonth.month}',
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: action, borderRadius: .circular(18)),
          height: 350,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (value) {
              focusMonth = DateTime(
                focusMonth.year,
                focusMonth.month + (value - 12),
              );
              setState(() {});
            },
            itemBuilder: (context, index) => GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              children: .generate(dates.length, (index) {
                final date = dates[index];
                return Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: date.month != focusMonth.month
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
    leading: Center(child: Text('ToDo', style: TextStyle(fontWeight: .bold, fontSize: 24))),
    actionsPadding: .only(right: 20),
    actions: [
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => WritePage()),
        ),
        child: Container(
          padding: .all(12),
          decoration: BoxDecoration(color: action, shape: .circle),
          child: Icon(Icons.add),
        ),
      ),
    ],
  );
}
