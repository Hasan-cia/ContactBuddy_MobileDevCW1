// screens/edit_contact_screen.dart

import 'package:contacts_buddy/screens/home_screen.dart';
import 'package:contacts_buddy/widgets/confirmation_dialog.dart';
import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:contacts_buddy/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/database/database_helper.dart';

import '../utils/validator.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;
  final bool isSlide;

  EditContactScreen({required this.contact, required this.isSlide});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    phoneController = TextEditingController(text: widget.contact.phone);
    emailController = TextEditingController(text: widget.contact.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomInputField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            CustomInputField(
              controller: phoneController,
              label: 'Phone No',
              icon: Icons.phone,
              keyboardType: TextInputType.number,
            ),
            CustomInputField(
              controller: emailController,
              label: 'Mail Address',
              icon: Icons.email,
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Save Changes',
              onPressed: () {
                if (validateInputs(context, nameController.text,
                    phoneController.text, emailController.text)) {
                  _saveChanges(context);
                }
              },
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges(BuildContext context) {
    // Show the confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Save',
          content: 'Are you sure you want to save changes?',
          actions: [
            ConfirmationAction(
              text: 'Save',
              onPressed: () {
                Contact updatedContact = widget.contact.copyWith(
                  name: nameController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                );

                DatabaseHelper.instance.updateContact(updatedContact).then((_) {
                  if (widget.isSlide) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ); // Close the EditContactScreen
                  } else {
                    Navigator.pop(context); // Close the EditContactScreen
                  }
                });
              },
            ),
            ConfirmationAction(
              text: 'Cancel',
              onPressed: () {
                if (widget.isSlide) {
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
