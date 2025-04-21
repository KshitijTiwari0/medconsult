import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InformationFormPage extends StatefulWidget {
  const InformationFormPage({super.key, required this.email});
  final String email;

  @override
  State<InformationFormPage> createState() => _InformationFormPageState();
}

class _InformationFormPageState extends State<InformationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _diseaseDetailsController = TextEditingController();
  final _medicationDetailsController = TextEditingController();
  final _allergyDetailsController = TextEditingController();

  bool _hasDiseases = false;
  bool _hasMedications = false;
  bool _hasAllergies = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _diseaseDetailsController.dispose();
    _medicationDetailsController.dispose();
    _allergyDetailsController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          'https://kshitij181.app.n8n.cloud/webhook-test/7afd299f-db64-45b6-a4c1-378c0e8517c4');
      final data = {
        'email': widget.email,
        'name': _nameController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
        'diseases': _hasDiseases ? _diseaseDetailsController.text : null,
        'medications': _hasMedications ? _medicationDetailsController.text : null,
        'allergies': _hasAllergies ? _allergyDetailsController.text : null,
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Form submission failed: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Information Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const Text('Do you have any diseases?'),
              Row(
                children: <Widget>[
                  Radio<bool>(
                    value: true,
                    groupValue: _hasDiseases,
                    onChanged: (bool? value) {
                      setState(() {
                        _hasDiseases = value!;
                      });
                    },
                  ),
                  const Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: _hasDiseases,
                    onChanged: (bool? value) {
                      setState(() {
                        _hasDiseases = value!;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              if (_hasDiseases)
                TextFormField(
                  controller: _diseaseDetailsController,
                  decoration:
                      const InputDecoration(labelText: 'Disease Details'),
                ),
              const Text('Do you take any medications?'),
              Row(
                children: <Widget>[
                  Radio<bool>(
                    value: true,
                    groupValue: _hasMedications,
                    onChanged: (bool? value) {
                      setState(() {
                        _hasMedications = value!;
                      });
                    },
                  ),
                  const Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: _hasMedications,
                    onChanged: (bool? value) {
                      setState(() {
                        _hasMedications = value!;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              if (_hasMedications)
                TextFormField(
                  controller: _medicationDetailsController,
                  decoration:
                      const InputDecoration(labelText: 'Medication Details'),
                ),
              const Text('Do you have any allergies?'),
              Row(
                children: <Widget>[
                  Radio<bool>(
                    value: true,
                    groupValue: _hasAllergies,
                    onChanged: (bool? value) {
                      setState(() {
                        _hasAllergies = value!;
                      });
                    },
                  ),
                  const Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: _hasAllergies,
                    onChanged: (bool? value) {
                      setState(() {
                        _hasAllergies = value!;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              if (_hasAllergies)
                TextFormField(
                  controller: _allergyDetailsController,
                  decoration:
                      const InputDecoration(labelText: 'Allergy Details'),
                ),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}