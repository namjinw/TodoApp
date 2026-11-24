import 'package:dart_my/page/detail.dart';
import 'package:dart_my/page/setting.dart';
import 'package:dart_my/page/widget/day_list.dart';
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

  final PageController pageController = PageController();

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

  Widget todoCard(ToDo item) => GestureDetector(
    onTap: () => Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailPage(todo: item)),
    ),
    child: Container(
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
    ),
  );

  int index = 0;

  // 현재 달력 PageView 자식 GridView들이 모두 같은 달만 있음
  // 12개 <= 11월달만 가짐
  // 문제: PageView를 넘길 시 달력이 넘겨지면서
  //       현달 내용이 보여지고 변함
  // 해결: 각 달력 GridView마다 다른 달을 넣음.
  Widget calendar(List<ToDo> todos) {
    final calenderDates = List.generate(
      13,
      (index) => getCalendarDays(DateTime(today.year, today.month + index)),
    );

    return Column(
      children: [
        Stack(
          alignment: .center,
          children: [
            Text(
              style: TextStyle(fontWeight: .bold, fontSize: 32),
              '${focusMonth.year}, ${focusMonth.month}',
            ),
            Align(
              alignment: .centerRight,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => WritePage()),
                ),
                child: Container(
                  padding: .all(8),
                  decoration: BoxDecoration(color: action, shape: .circle),
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: action, borderRadius: .circular(18)),
          height: 410,
          padding: .all(10),
          child: PageView.builder(
            controller: pageController,
            physics: PageScrollPhysics(),
            itemCount: 13,
            onPageChanged: (value) {
              focusMonth = DateTime(
                focusMonth.year,
                focusMonth.month + (index < value ? 1 : -1),
              );
              index = value;
              setState(() {});
              print(focusMonth);
            },
            itemBuilder: (context, index) =>
                calenderView(calenderDates[index], todos),
          ),
        ),
      ],
    );
  }

  Widget calenderView(List<DateTime> dates, List<ToDo> todos) => GridView(
    padding: .zero,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      mainAxisExtent: 60,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
    ),
    children: .generate(dates.length, (index) => dateItem(dates[index], todos)),
  );

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
    final isToday =
        today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => DayListDialog(date: date),
      ),
      child: Container(
        padding: .only(left: 6, top: 5),
        decoration: BoxDecoration(
          color: isToday ? secondary : fill,
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
          children: [
            Text(
              '${date.day}',
              overflow: .ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontWeight: .bold,
                color: date.month != focusMonth.month
                    ? Colors.grey
                    : (isToday ? Colors.white : Colors.black),
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
    surfaceTintColor: Colors.transparent,
    leadingWidth: 100,
    leading: Center(
      child: Text('ToDo', style: TextStyle(fontWeight: .bold, fontSize: 24)),
    ),
    actionsPadding: .only(right: 8),
    actions: [
      IconButton(
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => SettingPage()),
        ),
        icon: Icon(Icons.settings, size: 30, color: primary),
      ),
    ],
  );
}
