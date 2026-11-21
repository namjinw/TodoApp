import 'package:dart_my/controller/to_do_controller.dart';
import 'package:dart_my/util/color.dart';
import 'package:dart_my/util/util.dart';
import 'package:flutter/material.dart';

class RegisterTagDialog extends StatefulWidget {
  const RegisterTagDialog({super.key});

  @override
  State<RegisterTagDialog> createState() => _RegisterTagDialogState();
}

class _RegisterTagDialogState extends State<RegisterTagDialog> {
  final TextEditingController tag = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  void submit() {
    if (key.currentState!.validate()) {
      ToDoController.addElement(tag.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: neutral,
      title: Center(
        child: Text(
          '태그 생성',
          style: TextStyle(
            color: Colors.white,
            fontWeight: .bold,
            fontSize: 24,
          ),
        ),
      ),
      content: Form(
        key: key,
        child: TextFormField(
          onEditingComplete: () => submit(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '태그 이름을 입력해주세요';
            }
            return null;
          },
          controller: tag,
          decoration: fieldStyle('태그를 입력해주세요'),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => submit(),
          child: Container(
            alignment: .center,
            width: sizew(context),
            padding: .symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: .circular(4),
            ),
            child: Text(
              '태그 생성하기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: .bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
