import 'package:flutter/material.dart';

// In-memory storage (replace with a database in a real app)
final personalDetails = <String, Map<String, dynamic>>{};

class PersonalDetailsPage extends StatefulWidget {
  final String email;
  final Map<String, String>? initialDetails;

  const PersonalDetailsPage({
    super.key,
    required this.email,
    this.initialDetails,
  });
  @override
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    if (widget.initialDetails != null) {
       _nameController.text = widget.initialDetails!['name'] ?? '';
        if (widget.initialDetails!.containsKey('age')) {
          _ageController.text = widget.initialDetails!['age'] ?? '';
        } else
          _ageController.text='';
    } else if (personalDetails.containsKey(widget.email)) {
        final userDetails = personalDetails[widget.email];
      if (userDetails!= null && userDetails.containsKey('age')) {
          _ageController.text = userDetails['age'].toString();
        } else
          _ageController.text='';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final age = int.parse(_ageController.text);

                    personalDetails[widget.email] = {'name': name, 'age': age};

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Details saved successfully!'),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
