import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:myapp/response_page.dart';
import 'main.dart';

class InformationFormPage extends StatefulWidget {
  const InformationFormPage({super.key, required this.email});
  final String email;

  @override
  State<InformationFormPage> createState() => _InformationFormPageState();
}

class _InformationFormPageState extends State<InformationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  String _sex = 'Male';
  String? _reasonForVisit = null;
  final _reasonDescriptionController = TextEditingController();
  String? _durationOfIssue = null;
  String? _progression = null;
  String? _isFirstTime = null;
  final _mainSymptomController = TextEditingController();
  final _relatedSymptomsController = TextEditingController();
  final _chronicConditionsController = TextEditingController();
  final _medicationNameController = TextEditingController();
  final _medicationDosageController = TextEditingController();
  final _medicationFrequencyController = TextEditingController();
  String _allergies = 'None';
  final _recentTestsTypeController = TextEditingController();
  final _recentTestsNotesController = TextEditingController();
  double _perceivedSeverity = 3;
  bool _thoughtAboutER = false;
  final _whatHelpedController = TextEditingController();
  String? _whatDoYouExpect = null;
  List relatedSymptomsSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    if (userDatabase.containsKey(widget.email)) {
      final userDetails = userDatabase[widget.email];
      if (userDetails != null) {
        _firstNameController.text = userDetails['firstName'] ?? '';
        _lastNameController.text = userDetails['lastName'] ?? '';
        _ageController.text = userDetails['age'] ?? '';
        _phoneController.text = userDetails['phone'] ?? '';
        _sex = userDetails['sex'] ?? 'Male';
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _reasonDescriptionController.dispose();
    _mainSymptomController.dispose();
    _relatedSymptomsController.dispose();
    _chronicConditionsController.dispose();
    _medicationNameController.dispose();
    _medicationDosageController.dispose();
    _medicationFrequencyController.dispose();
    _recentTestsTypeController.dispose();
    _recentTestsNotesController.dispose();
     _whatHelpedController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'email': widget.email,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'age': _ageController.text,
        'sex': _sex,
        'phone': _phoneController.text,
        'reasonForVisit': _reasonForVisit,
        'reasonDescription': _reasonDescriptionController.text,
        'durationOfIssue': _durationOfIssue,
        'progression': _progression,
        'isFirstTime': _isFirstTime,
        'mainSymptom': _mainSymptomController.text,
        'relatedSymptoms': _relatedSymptomsController.text,
        'chronicConditions': _chronicConditionsController.text,
        'medicationName': _medicationNameController.text,
        'medicationDosage': _medicationDosageController.text,
        'medicationFrequency': _medicationFrequencyController.text,
         'allergies': _allergies,
        'recentTestsType': _recentTestsTypeController.text,
        'recentTestsNotes': _recentTestsNotesController.text,
        'perceivedSeverity': _perceivedSeverity,
        'thoughtAboutER': _thoughtAboutER,
        'whatHelped': _whatHelpedController.text,
        'whatDoYouExpect': _whatDoYouExpect,
      };

      try {
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResponsePage(data: data),
              ));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Data sent correctly!'),
                backgroundColor: Colors.green,
              ),
            );
          }
           userDatabase[widget.email] = {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'age': _ageController.text,
            'phone': _phoneController.text,
            'sex': _sex,
          };
      } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Information Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION 1: Identification and Context
              const Text(
                "Identification and Context",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
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
              DropdownButtonFormField(
                value: _sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sex = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your sex';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              // Email is pre-filled and non-editable
              TextFormField(
                initialValue: widget.email,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              // SECTION 2: Reason for the Visit
              const SizedBox(height: 20),
              const Text(
                "Reason for Visit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Reason for Visit'),
                items: const [
                  DropdownMenuItem(
                      value: 'pain/symptoms', child: Text('Pain/Symptoms')),
                  DropdownMenuItem(value: 'check-up', child: Text('Check-up')),
                  DropdownMenuItem(
                      value: 'test results', child: Text('Test Results')),
                  DropdownMenuItem(
                      value: 'prescription', child: Text('Prescription')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _reasonForVisit = value),
                validator: (value) =>
                    value == null ? 'Please select a reason' : null,
              ),
              TextFormField(
                controller: _reasonDescriptionController,
                decoration:
                    const InputDecoration(labelText: 'Personal Description of Reason'),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Duration of Issue'),
                items: const [
                  DropdownMenuItem(value: 'hours', child: Text('Hours')),
                  DropdownMenuItem(value: 'days', child: Text('Days')),
                  DropdownMenuItem(value: 'weeks', child: Text('Weeks')),
                  DropdownMenuItem(value: 'months', child: Text('Months')),
                ],
                onChanged: (value) => setState(() => _durationOfIssue = value),
                validator: (value) =>
                    value == null ? 'Please select the duration' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Progression'),
                items: const [
                  DropdownMenuItem(value: 'worsened', child: Text('Worsened')),
                  DropdownMenuItem(value: 'stable', child: Text('Stable')),
                  DropdownMenuItem(value: 'improved', child: Text('Improved')),
                ],
                onChanged: (value) => setState(() => _progression = value),
                validator: (value) =>
                    value == null ? 'Please select the progression' : null,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Is this the first time?'),
                items: const [
                  DropdownMenuItem(value: 'yes', child: Text('Yes')),
                  DropdownMenuItem(value: 'no', child: Text('No')),
                  DropdownMenuItem(
                      value: 'recurring episode', child: Text('Recurring Episode')),
                ],
                onChanged: (value) => setState(() => _isFirstTime = value),
                validator: (value) =>
                    value == null ? 'Please select an option' : null,
              ),
              // SECTION 3: Symptoms and Associated Symptoms
              const SizedBox(height: 20),
              const Text(
                "Symptoms and Associated Symptoms",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mainSymptomController,
                decoration: const InputDecoration(labelText: 'Main Symptom'),
                onChanged: (value) {
                  // Placeholder for symptom suggestion logic
                  setState(() {
                    relatedSymptomsSuggestions = ['Symptom 1', 'Symptom 2', value];
                  });
                },
              ),
              TextFormField(
                controller: _relatedSymptomsController,
                decoration: InputDecoration(
                    labelText:
                        'Related Symptoms (e.g., ${relatedSymptomsSuggestions.join(", ")})'),
              ),
              // SECTION 4: Conditions, Medications, Tests
              const SizedBox(height: 20),
              const Text(
                "Conditions, Medications, Tests",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _chronicConditionsController,
                decoration: const InputDecoration(
                    labelText: 'Chronic Conditions (e.g., diabetes, hypertension)'),
              ),
              TextFormField(
                controller: _medicationNameController,
                decoration: const InputDecoration(labelText: 'Medication Name'),
              ),
              TextFormField(
                controller: _medicationDosageController,
                decoration: const InputDecoration(labelText: 'Medication Dosage'),
              ),
              TextFormField(
                controller: _medicationFrequencyController,
                decoration: const InputDecoration(labelText: 'Medication Frequency'),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Allergies'),
                value: _allergies == "None" ? "none" : _allergies,
                items: const [
                  DropdownMenuItem(value: 'medications', child: Text('Medications')),
                  DropdownMenuItem(value: 'foods', child: Text('Foods')),

                  DropdownMenuItem(value: 'other', child: Text('Other')),
                  DropdownMenuItem(value: 'none', child: Text('None')),
                ],
                onChanged: (value) => setState(() => _allergies = value!),
                validator: (value) =>
                    value == null ? 'Please select an option' : null,
              ),
              TextFormField(
                controller: _recentTestsTypeController,
                decoration: const InputDecoration(labelText: 'Recent Tests (Type)'),
              ),
              TextFormField(
                controller: _recentTestsNotesController,
                decoration: const InputDecoration(labelText: 'Recent Tests Notes'),
              ),
              // Placeholder for file upload (requires file_picker package)
              const Text(
                'File Upload: Not implemented (use file_picker for production)',
                style: TextStyle(color: Colors.grey),
              ),
              // SECTION 5: Perception of the Problem and Patient Goals
              const SizedBox(height: 20),
              const Text(
                "Perception of the Problem and Patient Goals",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text('Perceived Severity (1-5): ${_perceivedSeverity.toInt()}'),
              Slider(
                value: _perceivedSeverity,
                min: 1,
                max: 5,
                divisions: 4,
                label: _perceivedSeverity.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _perceivedSeverity = value;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Have you thought about going to the ER?"),
                value: _thoughtAboutER,
                onChanged: (value) {
                  setState(() {
                    _thoughtAboutER = value!;
                  });
                },
              ),
              TextFormField(
                controller: _whatHelpedController,
                decoration: const InputDecoration(
                    labelText:
                        'What have you done to feel better? (rest, medication, etc.)'),
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'What do you expect from the visit?'),
                items: const [
                  DropdownMenuItem(value: 'diagnosis', child: Text('Diagnosis')),
                  DropdownMenuItem(value: 'prescription', child: Text('Prescription')),
                  DropdownMenuItem(value: 'reassurance', child: Text('Reassurance')),
                  DropdownMenuItem(value: 'follow-up', child: Text('Follow-up')),
                ],
                onChanged: (value) => setState(() => _whatDoYouExpect = value),
                validator: (value) =>
                    value == null ? 'Please select an option' : null,
              ),
              // Submit Button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
