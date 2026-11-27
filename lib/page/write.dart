import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/model/to_do.dart';
import 'package:dart_my/page/widget/delete_item.dart';
import 'package:dart_my/page/widget/register_tag.dart';
import 'package:dart_my/util/color.dart';
import 'package:dart_my/util/media.dart';
import 'package:dart_my/util/native.dart';
import 'package:dart_my/util/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController title = TextEditingController();
  List<String> tag = [];
  final lastDate = DateTime(DateTime.now().year + 1, DateTime.now().month);
  final TextEditingController content = TextEditingController();
  Color color = Colors.redAccent;
  DateTime date = DateTime.now();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), backgroundColor: neutral, body: body());
  }

  Widget body() => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Padding(
      padding: .symmetric(vertical: 20, horizontal: 15),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(12),
          ),
          padding: .all(15),
          child: Form(
            key: key,
            child: Column(
              spacing: 30,
              children: [
                input('제목', '제목을 입력해주세요', title, (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                }),
                insertTag(),
                input('내용', '내용을 입력해주세요', isOne: false, content, (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                }),
                colorPick(),
                datePick(),
                button(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget button() => GestureDetector(
    onTap: () async {
      if (key.currentState!.validate()) {
        final status = await statusForeground();
        print(status);
        if (status) startForground();
        await ToDoController.addElement(
          ToDo(
            id: DateTime.now().microsecondsSinceEpoch,
            title: title.text,
            content: content.text,
            tag: tag,
            date: date,
            color: color,
            createdAt: DateTime.now(),
          ),
        );
        Navigator.pop(context);
        snack(context, '할일이 등록 되었습니다!', Icons.celebration_outlined);
      }
    },
    child: Container(
      width: sizew(context),
      padding: .symmetric(vertical: 12),
      alignment: .center,
      decoration: BoxDecoration(color: primary, borderRadius: .circular(4)),
      child: Text(
        '할일 등록하기',
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: .bold),
      ),
    ),
  );

  Widget datePick() => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      Align(
        alignment: .centerLeft,
        child: Text('날짜 선택', style: TextStyle(fontSize: subTitleSize, fontWeight: .bold)),
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '${DateFormat('y년 M월 d일').format(date)}',
                style: TextStyle(
                  color: primary,
                  fontWeight: .bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? dateTime = await showDatePicker(
                confirmText: '선택',
                cancelText: '닫기',
                helpText: '할일 날짜 선택',
                fieldHintText: '"일/월/년도"를 입력해주세요',
                fieldLabelText: '날짜 입력',
                errorInvalidText:
                    '날짜는 오늘~${DateFormat('y.M.d').format(lastDate)}까지 입니다.',
                errorFormatText: '올바른 값을 입력해주세요',
                initialDate: date,
                context: context,
                firstDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context)
                      .copyWith(colorScheme: .fromSeed(seedColor: primary)),
                  child: child!,
                ),
                lastDate: lastDate,
              );

              if (dateTime != null) {
                date = dateTime;
                setState(() {});
              }
            },
            child: Container(
              padding: .symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: .circular(4),
              ),
              child: Text(
                '날짜 선택',
                style: TextStyle(color: Colors.white, fontWeight: .bold),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  Widget colorPick() => Column(
    crossAxisAlignment: .start,
    spacing: 8,
    children: [
      Align(
        alignment: .centerLeft,
        child: Text('색상 선택', style: TextStyle(fontSize: subTitleSize, fontWeight: .bold)),
      ),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: .generate(colors.length, (index) {
          final c = colors[index];
          final selected = c == color;

          return GestureDetector(
            onTap: () {
              color = c;
              setState(() {});
            },
            child: Container(
              width: sizew(context) * 0.12,
              height: sizew(context) * 0.12,
              decoration: BoxDecoration(color: c, borderRadius: .circular(4)),
              child: Icon(
                Icons.check,
                shadows: [
                  Shadow(
                    color: selected
                        ? Colors.black.withAlpha(100)
                        : Colors.transparent,
                    blurRadius: 4,
                  ),
                ],
                color: selected ? Colors.white : Colors.transparent,
                size: 40,
              ),
            ),
          );
        }),
      ),
    ],
  );

  Widget insertTag() => ValueListenableBuilder(
    valueListenable: ToDoController.tags,
    builder: (context, t, child) => Column(
      crossAxisAlignment: .start,
      children: [
        Align(
          alignment: .centerLeft,
          child: Text(
            '태그 등록',
            style: TextStyle(fontSize: subTitleSize, fontWeight: .bold),
          ),
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: .horizontal,
          child: Row(
            spacing: 6,
            children: [
              addChip(),
              ....generate(t.length, (index) => tagChip(t[index])),
            ],
          ),
        ),
      ],
    ),
  );

  Widget tagChip(t) {
    final color = tag.contains(t) ? Colors.white : primary;

    return GestureDetector(
      onLongPress: () {
        if (!tag.contains(t)) {
          showDialog(
            context: context,
            builder: (context) => DeleteItemDialog(
              element: '태그',
              content: '"${t}"태그를',
              function: () {
                ToDoController.deleteTag(t);
                snack(
                  context,
                  '"${t}"태그가 삭제되었습니다.',
                  Icons.delete_outline,
                  act: SnackBarAction(
                    label: '취소',
                    textColor: Colors.white,
                    onPressed: () => ToDoController.addElement(t),
                  ),
                );
              },
            ),
          );
        }
      },
      child: FilterChip(
        padding: .all(2),
        label: Row(
          spacing: 5,
          children: [Text(t, style: TextStyle(color: color))],
        ),
        selected: tag.contains(t),
        selectedColor: primary,
        checkmarkColor: color,
        backgroundColor: fill,
        onSelected: (value) {
          value ? tag.add(t) : tag.remove(t);
          setState(() {});
        },
      ),
    );
  }

  Widget addChip() => ActionChip(
    padding: .all(2),
    elevation: 0.4,
    backgroundColor: primary,
    side: BorderSide(color: Colors.transparent),
    label: Icon(Icons.add, color: Colors.white),
    onPressed: () =>
        showDialog(context: context, builder: (context) => RegisterTagDialog()),
  );

  Widget input(
    text,
    hint,
    TextEditingController value,
    String? Function(String?) valid, {
    isOne = true,
  }) => Column(
    spacing: 8,
    crossAxisAlignment: .start,
    children: [
      Text(text, style: TextStyle(fontSize: subTitleSize, fontWeight: .bold)),
      TextFormField(
        maxLines: isOne ? 1 : null,
        controller: value,
        validator: valid,
        decoration: fieldStyle(hint),
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
    title: Text('할일 생성', style: TextStyle(fontSize: titleSize, fontWeight: .bold)),
  );
}
