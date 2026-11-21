import 'package:dart_my/page/widget/register_tag.dart';
import 'package:dart_my/util/color.dart';
import 'package:dart_my/util/util.dart';
import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final TextEditingController title = TextEditingController();
  List<String> tag = [];
  final TextEditingController content = TextEditingController();
  Color? color;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), backgroundColor: neutral, body: body());
  }

  Widget body() => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Padding(
      padding: .symmetric(vertical: 20, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(12),
        ),
        padding: .all(12),
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
              return null;
            }),
            button(),
          ],
        ),
      ),
    ),
  );

  Widget button() => GestureDetector(
    onTap: () {},
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

  Widget insertTag() => Column(
    crossAxisAlignment: .start,
    children: [
      Text('태그 등록', style: TextStyle(fontSize: 24, fontWeight: .bold)),
      Row(
        children: [
          ActionChip(
            padding: .all(2),
            elevation: 0.4,
            backgroundColor: Colors.blue,
            side: BorderSide(color: Colors.transparent),
            label: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => RegisterTagDialog(),
              );
            },
          ),
        ],
      ),
    ],
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
      Text(text, style: TextStyle(fontSize: 24, fontWeight: .bold)),
      TextFormField(
        maxLines: isOne ? 1 : null,
        controller: value,
        validator: valid,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: fill,
          contentPadding: .symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: .circular(4),
            borderSide: BorderSide(color: border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: .circular(4),
            borderSide: BorderSide(color: focusBorder, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: .circular(4),
            borderSide: BorderSide(color: errorBorder, width: 1),
          ),
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
    title: Text('할일 생성', style: TextStyle(fontSize: 32, fontWeight: .bold)),
  );
}
