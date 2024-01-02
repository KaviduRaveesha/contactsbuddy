import 'package:flutter/material.dart';
import 'package:mobile/screen/add_contact_screen.dart';
import 'db/database_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  DatabaseHandler handler = DatabaseHandler();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshContacts();
  }

  void _refreshContacts() async {
    List<Contact> allContacts = await handler.retrieveContacts();
    setState(() {
      contacts = allContacts;
      filteredContacts = contacts;
    });
  }

  void _deleteContact(int id) async {
    await handler.deleteContact(id);
    _refreshContacts();
  }

  void _showContactDetails(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: ${contact.name}'),
            Text('Number: ${contact.number}'),
            Text('Email: ${contact.email}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the details dialog
              await _showUpdateDialog(contact);
              _refreshContacts(); // Refresh contacts after updating
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUpdateDialog(Contact contact) async {
    TextEditingController nameController = TextEditingController(text: contact.name);
    TextEditingController numberController = TextEditingController(text: contact.number);
    TextEditingController emailController = TextEditingController(text: contact.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Contact'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name:'),
              TextField(controller: nameController),
              SizedBox(height: 16),
              Text('Number:'),
              TextField(controller: numberController),
              SizedBox(height: 16),
              Text('Email:'),
              TextField(controller: emailController),
              SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Get the updated values from the text controllers
              String updatedName = nameController.text;
              String updatedNumber = numberController.text;
              String updatedEmail = emailController.text;

              // Validate if the required fields are not empty
              if (updatedName.isNotEmpty && updatedNumber.isNotEmpty && updatedEmail.isNotEmpty) {
                // Create a new Contact object with updated details
                Contact updatedContact = Contact(
                  id: contact.id,
                  name: updatedName,
                  number: updatedNumber,
                  email: updatedEmail,
                );

                // Update the contact in the database
                await handler.updateContact(updatedContact);

                Navigator.pop(context);
                _refreshContacts(); // Close the update dialog
              } else {
                // Show an error message or handle the case where some fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all required fields.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _filterContacts(String query) {
    List<Contact> filtered = contacts
        .where((contact) => contact.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredContacts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts Buddy'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredContacts[index].name),
                  subtitle: Text(filteredContacts[index].number),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Contact'),
                              content: Text('Are you sure you want to delete this contact?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteContact(filteredContacts[index].id!);
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showContactDetails(filteredContacts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          );
          _refreshContacts(); // Call _refreshContacts after navigating back from AddContactScreen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
