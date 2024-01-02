import 'package:flutter/material.dart';

class Contact {
  int? id;
  String? name;
  String? number;
  String? email;

  Contact({this.id, this.name, this.number, this.email});

  // Other methods and properties...

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'email': email,
    }..removeWhere((key, value) => value == null);
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      number: map['number'],
      email: map['email'],
    );
  }
}

class ContactPage extends StatefulWidget {
  get name => null;

  get number => null;

  get email => null;

  get id => null;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Number'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveContact();
              },
              child: Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    Contact newContact = Contact(
      name: _nameController.text,
      number: _numberController.text,
      email: _emailController.text,
    );

    // TODO: Save the newContact to the database or perform other actions.

    // Optionally, you can navigate back to the previous screen or perform other actions.
    Navigator.pop(context, newContact);
  }
}
