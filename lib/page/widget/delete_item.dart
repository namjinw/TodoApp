import 'package:dart_my/util/color.dart';
import 'package:flutter/material.dart';

import '../../util/util.dart';

class DeleteItemDialog extends StatefulWidget {
  final String element;
  final String content;
  final void Function() function;

  const DeleteItemDialog({
    super.key,
    required this.element,
    required this.content,
    required this.function,
  });

  @override
  State<DeleteItemDialog> createState() => _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: neutral,
      title: Center(
        child: Text(
          '${widget.element} 삭제',
          style: TextStyle(
            color: infoText,
            fontWeight: .bold,
            fontSize: 24,
          ),
        ),
      ),
      content: Text(
        textAlign: .center,
        '정말로 ${widget.content} 삭제하시겠습니까?',
        style: TextStyle(color: infoText, fontSize: 15, fontWeight: .bold),
      ),
      actionsAlignment: .spaceBetween,
      actions: [
        Row(
          spacing: 10,
          children: [
            btn(() => Navigator.pop(context), '취소', action, primary),
            btn(
              () {
                widget.function();
                Navigator.pop(context);
              },
              '삭제',
              Colors.red,
              Colors.white
            ),
          ],
        ),
      ],
    );
  }

  Widget btn(ontap, text, color, textColor) => Expanded(
    child: GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: .center,
        padding: .symmetric(vertical: 12),
        decoration: BoxDecoration(color: color, borderRadius: .circular(4)),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: .bold, fontSize: 18),
        ),
      ),
    ),
  );
}
