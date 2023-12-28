import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ConfirmationAction {
  final String text;
  final VoidCallback onPressed;

  ConfirmationAction({required this.text, required this.onPressed});
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<ConfirmationAction> actions;

  ConfirmationDialog({
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions
          .map(
            (action) => CustomButton(
              text: action.text,
              onPressed: () {
                action.onPressed();
                Navigator.pop(context);
              },
              isPrimary: action.text == 'Save' || action.text == 'Update',
              isDanger: action.text == 'Delete',
            ),
          )
          .toList(),
    );
  }
}
