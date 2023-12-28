import 'package:flutter/services.dart';
import 'package:contacts_buddy/screens/edit_contact_screen.dart';
import 'package:contacts_buddy/widgets/confirmation_dialog.dart';
import 'package:contacts_buddy/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/models/contact.dart';
import 'package:contacts_buddy/screens/add_contact_screen.dart';
import 'package:contacts_buddy/database/database_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Contact>> contacts;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    refreshContactList();
  }

  Future<void> refreshContactList() async {
    setState(() {
      contacts = DatabaseHelper.instance.getContacts();
    });
  }

  Future<void> searchContacts(String query) async {
    setState(() {
      contacts = DatabaseHelper.instance.searchContacts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textCapitalization: TextCapitalization.words,
          controller: searchController,
          focusNode: searchFocus,
          decoration: InputDecoration(
            hintText: 'Search contacts',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {
            searchContacts(query);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              searchFocus.unfocus();
              refreshContactList();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: contacts,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No contacts available. Add some contacts!'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Contact contact = snapshot.data![index];
              String firstLetter =
                  contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '';
              return Slidable(
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) {
                        _deleteContact(context, contact.id!, true);
                      },
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      autoClose: true,
                      backgroundColor: Colors.blueAccent,
                      icon: Icons.edit,
                      onPressed: (context) {
                        _editContact(context, contact, true);
                      },
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(firstLetter),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  onTap: () {
                    _showContactDetails(context, contact);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          ).then((_) => refreshContactList());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Name: ${contact.name}'),
              ),
              ListTile(
                title: Text('Phone: ${contact.phone}'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.content_copy,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _copyToClipboard(contact.phone);
                    Navigator.pop(context);
                    // showCustomToast('Number Copied', ToastType.success);
                  },
                ),
              ),
              ListTile(
                title: Text('Email: ${contact.email}'),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Edit Contact',
                onPressed: () {
                  _editContact(context, contact, false);
                },
                isPrimary: true,
              ),
              CustomButton(
                text: 'Delete Contact',
                onPressed: () {
                  _deleteContact(context, contact.id!, false);
                },
                isDanger: true,
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // You can show a toast or snackbar to indicate that the number has been copied.
  }

  void _editContact(BuildContext context, Contact contact, bool fromSlidable) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditContactScreen(contact: contact, isSlide: fromSlidable),
      ),
    ).then((_) => refreshContactList());
  }

  void _deleteContact(BuildContext context, int contactId, bool fromSlidable) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Delete',
          content: 'Are you sure you want to delete this contact?',
          actions: [
            ConfirmationAction(
              text: 'Cancel',
              onPressed: () {
                if (fromSlidable) {
                  // Navigator.pop(context); // Close the Slidable
                } else {
                  Navigator.pop(context); // Close the modal
                }
              },
            ),
            ConfirmationAction(
              text: 'Delete',
              onPressed: () {
                DatabaseHelper.instance.deleteContact(contactId).then((_) {
                  // Refresh the contact list
                  if (fromSlidable) {
                    // Navigator.pop(context); // Close the Slidable
                  } else {
                    Navigator.pop(context); // Close the modal
                  }
                  refreshContactList();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
