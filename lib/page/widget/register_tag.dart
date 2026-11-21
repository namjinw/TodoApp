import 'package:flutter/material.dart';

class RegisterTagDialog extends StatefulWidget {
  const RegisterTagDialog({super.key});

  @override
  State<RegisterTagDialog> createState() => _RegisterTagDialogState();
}

class _RegisterTagDialogState extends State<RegisterTagDialog> {
  final TextEditingController tag = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
        content: TextFormField(
          onEditingComplete: () {

                    },
          controller: tag,
          decoration: InputDecoration(

          ),
        ),
    );
  }
}
