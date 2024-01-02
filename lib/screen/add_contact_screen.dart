import 'package:flutter/material.dart';


import '../db/database_handler.dart.'; // Assuming you have a DatabaseHandler class

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            ElevatedButton(
              onPressed: () {
                _saveContact(context);
              },
              child: Text('Save Contact'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact(BuildContext context) async {
    // Get the values from the text controllers
    String name = nameController.text;
    String number = numberController.text;
    String email = emailController.text;

    // Validate if the required fields are not empty
    if (name.isNotEmpty && number.isNotEmpty && email.isNotEmpty) {
      // Create a new Contact object
      Contact newContact = Contact(
        name: name,
        number: number,
        email: email,
      );

      // Save the new contact to your database
      DatabaseHandler handler = DatabaseHandler();
      await handler.insertContact(newContact);

      // Navigate back to the home screen
      Navigator.pop(context, true); // Pass true to indicate that a new contact was added
    } else {
      // Show an error message or handle the case where some fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
