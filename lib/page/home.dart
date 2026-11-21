import 'package:dart_my/page/detail.dart';
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
  late List<ToDo> todayTodo;

  DateTime selectedDate = DateTime.now(); // 선택된 날짜
  DateTime focusMonth = DateTime.now(); // 달력 날짜

  final PageController pageController = PageController(initialPage: 12);

  // 할일 날짜랑 오늘 날짜랑 비교해서 오늘 할일만 가져와 리스트로 만들기
  void checkToday() => todayTodo = ToDoController.todos.value
      .where(
        (t) =>
            t.date.year == today.year &&
            t.date.month == today.month &&
            t.date.day == today.day,
      )
      .toList();

  @override
  void initState() {
    super.initState();
    ToDoController.todos.addListener(checkToday);
    checkToday();
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
      child: ValueListenableBuilder(
        valueListenable: ToDoController.todos,
        builder: (context, value, child) => Column(
          spacing: 30,
          crossAxisAlignment: .start,
          children: [calendar(value), todoItems(value)],
        ),
      ),
    ),
  );

  Widget todoItems(todos) => Column(
    crossAxisAlignment: .start,
    children: [
      Text(
        '${DateFormat('M월 d일').format(today)}',
        style: TextStyle(fontSize: 32, fontWeight: .bold, color: primary),
      ),
      SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: action, borderRadius: .circular(18)),
        padding: .symmetric(horizontal: 15, vertical: 20),
        child: todayTodo.isEmpty
            ? notItem()
            : Column(
                spacing: 15,
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
    decoration: BoxDecoration(color: secondary, borderRadius: .circular(12)),
    padding: .all(12),
    child: Column(
      spacing: 10,
      crossAxisAlignment: .start,
      children: [
        Row(
          spacing: 10,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: .circular(4),
              ),
            ),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  fontWeight: .bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (item.tag.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: .horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: .generate(
                item.tag.length,
                (index) => Container(
                  padding: .symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: .circular(6),
                  ),
                  child: Text(
                    item.tag[index],
                    style: TextStyle(color: Colors.white, fontWeight: .bold),
                  ),
                ),
              ),
            ),
          ),
        Container(
          width: sizew(context),
          padding: .all(10),
          decoration: BoxDecoration(color: fill, borderRadius: .circular(8)),
          child: Text(item.content),
        ),
      ],
    ),
  );

  Widget calendar(todos) {
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
          height: 410,
          padding: .all(10),
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
              padding: .zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 60,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              children: .generate(
                dates.length,
                (index) => dateItem(dates[index], todos),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget dateItem(DateTime date, List<ToDo> todos) {
    final list = todos
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
    final dayTodos = list.length > 3 ? list.sublist(1, 3) : list;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => DetailPage(date: date)),
      ),
      child: Container(
        padding: .only(left: 6, top: 5),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: .circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          spacing: 6,
          crossAxisAlignment: .start,
          mainAxisAlignment: .start,
          children: [
            Text(
              '${date.day}',
              overflow: .ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontWeight: .bold,
                color: date.month != focusMonth.month
                    ? Colors.grey
                    : Colors.black,
                fontSize: 18,
              ),
            ),
            Row(
              crossAxisAlignment: .start,
              spacing: 3,
              children: .generate(
                dayTodos.length,
                (index) => Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dayTodos[index].color,
                    borderRadius: .circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    leadingWidth: 100,
    leading: Center(
      child: Text('ToDo', style: TextStyle(fontWeight: .bold, fontSize: 24)),
    ),
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
