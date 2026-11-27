import 'package:dart_my/controller/setting_controller.dart';
import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/model/option.dart';
import 'package:dart_my/util/color.dart';
import 'package:dart_my/util/media.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: neutral,
      body: content(),
    );
  }

  Widget content() => ValueListenableBuilder(
    valueListenable: SettingController.options,
    builder: (context, value, child) => SingleChildScrollView(
      padding: .symmetric(horizontal: 20, vertical: 20),
      physics: BouncingScrollPhysics(),
      child: Column(children: [systemOptionList(value)]),
    ),
  );

  Widget systemOptionList(List<Option> option) => Container(
    padding: .all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: .circular(12)),
    child: Column(
      crossAxisAlignment: .start,
      spacing: 10,
      children: .generate(option.length > 3 ? 3 : option.length, (index) {
        final o = option[index];
        return baseOption(o);
      }),
    ),
  );

  Widget baseOption(Option o) => Material(
    color: Colors.white,
    child: CheckboxListTile(
      value: o.isActive,
      onChanged: (value) {
        o.isActive = !o.isActive;
        SettingController.funcs(o.id, o.isActive);
        setState(() {});
      },
      activeColor: primary,
      title: Text(
        o.title,
        style: TextStyle(fontSize: dateSellTextSize, fontWeight: .bold, color: primary),
      ),
      subtitle: Text(o.explanation, style: TextStyle(color: secondary, fontSize: textSize),),
    ),
  );

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    title: Text(
      '설정',
      style: TextStyle(color: primary, fontSize: titleSize, fontWeight: .bold),
    ),
    centerTitle: true,
    leadingWidth: 60,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back),
    ),
  );
}