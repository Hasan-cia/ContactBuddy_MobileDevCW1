import 'package:contacts_buddy/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

bool validateInputs(
  BuildContext context,
  String name,
  String phone,
  String email,
) {
  if (name.trim().isEmpty) {
    _showInvalidInputAlert(context, 'Please enter a name.');
    return false;
  }

  if (phone.trim().isEmpty) {
    _showInvalidInputAlert(context, 'Please enter a phone number.');
    return false;
  }

  // Validate phone number format
  final phoneRegex = RegExp(r'^[0-9]{9,}$');
  if (!phoneRegex.hasMatch(phone.trim())) {
    _showInvalidInputAlert(context, 'Please enter a valid phone number.');
    return false;
  }

  // Allow an empty email or validate email format
  if (email.trim().isNotEmpty) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(email.trim())) {
      _showInvalidInputAlert(context, 'Please enter a valid email address.');
      return false;
    }
  }

  return true;
}

// void _showErrorDialog(BuildContext context, String message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }

void _showInvalidInputAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return ConfirmationDialog(
        title: 'Invalid Input',
        content: message,
        actions: [
          ConfirmationAction(
            text: 'Cancel',
            onPressed: () {
              // Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
