// screens/add_contact_screen.dart

import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/utils/validator.dart';
import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:contacts_buddy/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/database/database_helper.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Email validation function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              text: 'Save Contact',
              onPressed: () {
                if (validateInputs(context, nameController.text,
                    phoneController.text, emailController.text)) {
                  Contact newContact = Contact(
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text);
                  DatabaseHelper.instance.insertContact(newContact);

                  Navigator.pop(context);
                }
              },
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }
}
