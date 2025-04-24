import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  // ignore: library_private_types_in_public_api
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _sex = 'Male';
  String? _reasonForVisit;
  final _reasonDescriptionController = TextEditingController();
  String? _durationOfIssue;
  String? _progression;
  String? _isFirstTime;
  final _mainSymptomController = TextEditingController();
  final _relatedSymptomsController = TextEditingController();
  final _chronicConditionsController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  String _allergies = 'None';
  final _recentTestsController = TextEditingController();
  final _recentTestsNotesController = TextEditingController();
  double _perceivedSeverity = 3;
  bool _thoughtAboutER = false;
  final _whatHelpedController = TextEditingController();
  String? _whatDoYouExpect;
  List<String> mainSymptoms = [];
  List<String> relatedSymptoms = [];
  List<String> chronicConditions = [];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    if (widget.initialDetails != null) {
       _nameController.text = widget.initialDetails!['name'] ?? '';
       _lastNameController.text = widget.initialDetails!['lastName'] ?? '';
       _emailController.text = widget.email;
       _phoneController.text = widget.initialDetails!['phone'] ?? '';
       _sex = widget.initialDetails!['sex'] ?? 'Male';
       if (widget.initialDetails!.containsKey('age')) {
         _ageController.text = widget.initialDetails!['age'] ?? '';
       } else {
         _ageController.text='';
       }
    } else if (personalDetails.containsKey(widget.email)) {
      final userDetails = personalDetails[widget.email];
      if(userDetails!=null){
        _nameController.text = userDetails['firstName'] ?? '';
        _lastNameController.text = userDetails['lastName'] ?? '';
        _emailController.text = widget.email;
        _phoneController.text = userDetails['phone'] ?? '';
        _sex = userDetails['sex'] ?? 'Male';
        if (userDetails.containsKey('age')) {
            _ageController.text = userDetails['age'].toString();
          } else {
          _ageController.text='';
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _reasonDescriptionController.dispose();
    _mainSymptomController.dispose();
    _relatedSymptomsController.dispose();
    _chronicConditionsController.dispose();
    _currentMedicationsController.dispose();
    _recentTestsController.dispose();
    _recentTestsNotesController.dispose();
    _whatHelpedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      // backgroundColor: Color.fromARGB(255, 235, 231, 231),
      extendBody: true,
      // floatingActionButton: FloatingActionButton(
      // ),
      appBar: AppBar(title: const Text('Personal Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // SECTION 1
              const Text("Identification and Context", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 10),
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                enabled: false,
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
              DropdownButtonFormField<String>(
                value: _sex,
                decoration: const InputDecoration(labelText: 'Sex'),
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
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

              // TextFormField(
              //   controller: _emailController,
              //   decoration: const InputDecoration(labelText: 'Email'),
              // ),
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
              //SECTION 2
              const SizedBox(height: 10),
              const Text("Reason for Visit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Reason for Visit'),
                items: const [
                  DropdownMenuItem(value: 'pain/symptoms', child: Text('Pain/Symptoms')),
                  DropdownMenuItem(value: 'check-up', child: Text('Check-up')),
                  DropdownMenuItem(value: 'test results', child: Text('Test Results')),
                  DropdownMenuItem(value: 'prescription', child: Text('Prescription')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _reasonForVisit = value),
                validator: (value) => value == null ? 'Please select a reason' : null,
              ),
              TextFormField(
                controller: _reasonDescriptionController,
                decoration: const InputDecoration(labelText: 'Personal Description of Reason'),
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
                validator: (value) => value == null ? 'Please select the duration' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Progression'),
                items: const [
                  DropdownMenuItem(value: 'worsened', child: Text('Worsened')),
                  DropdownMenuItem(value: 'stable', child: Text('Stable')),
                  DropdownMenuItem(value: 'improved', child: Text('Improved')),
                ],
                onChanged: (value) => setState(() => _progression = value),
                validator: (value) => value == null ? 'Please select the progression' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Is this the first time?'),
                items: const [
                  DropdownMenuItem(value: 'yes', child: Text('Yes')),
                  DropdownMenuItem(value: 'no', child: Text('No')),
                  DropdownMenuItem(value: 'recurring episode', child: Text('Recurring Episode')),
                ],
                onChanged: (value) => setState(() => _isFirstTime = value),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),
              //SECTION 3
              const SizedBox(height: 10),
              const Text("Symptoms and Associated Symptoms", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mainSymptomController,
                decoration: const InputDecoration(labelText: 'Main Symptom'),
                onChanged: (value) {
                  // Add logic to suggest related symptoms here based on the main symptom
                  setState(() {
                    // Simulate symptom suggestions
                    relatedSymptoms = ['Symptom 1', 'Symptom 2'];
                    relatedSymptoms.add(_mainSymptomController.text);
                  });
                },
              ),
              TextFormField(
                controller: _relatedSymptomsController,
                decoration: const InputDecoration(labelText: 'Related Symptoms (you can add more)'),
                // onChanged: (value) {
                //   setState(() {
                //     relatedSymptoms = value.split(",");
                //   });
                // },
              ),
              //SECTION 4
              const SizedBox(height: 10),
              const Text("Conditions, Medications, Tests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 10),
              TextFormField(
                controller: _chronicConditionsController,
                decoration: const InputDecoration(labelText: 'Chronic Conditions (list + editable)'),
              ),
              TextFormField(
                controller: _currentMedicationsController,
                decoration: const InputDecoration(labelText: 'Current Medications (name, dosage, frequency)'),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Allergies'),
                value: _allergies,
                items: const [
                  DropdownMenuItem(value: 'medications', child: Text('Medications')),
                  DropdownMenuItem(value: 'foods', child: Text('Foods')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                  DropdownMenuItem(value: 'none', child: Text('None')),
                ],
                onChanged: (value) => setState(() => _allergies = value!),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),
              TextFormField(
                controller: _recentTestsController,
                decoration: const InputDecoration(labelText: 'Recent Tests (type)'),
              ),
              TextFormField(
                controller: _recentTestsNotesController,
                decoration: const InputDecoration(labelText: 'Recent Tests Notes'),
              ),
              //SECTION 5
              const SizedBox(height: 10),
              const Text("Perception of the Problem and Patient Goals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              const SizedBox(height: 10),
              Text('Perceived Severity (1-5): ${_perceivedSeverity.toInt()}', textAlign: TextAlign.left,),
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
                decoration: const InputDecoration(labelText: 'What have you done to feel better? (rest, medication, etc.)'),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'What do you expect from the visit?'),
                items: const [
                  DropdownMenuItem(value: 'diagnosis', child: Text('Diagnosis')),
                  DropdownMenuItem(value: 'prescription', child: Text('Prescription')),
                  DropdownMenuItem(value: 'reassurance', child: Text('Reassurance')),
                  DropdownMenuItem(value: 'follow-up', child: Text('Follow-up')),
                ],
                onChanged: (value) => setState(() => _whatDoYouExpect = value),
                validator: (value) => value == null ? 'Please select an option' : null,
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    personalDetails[widget.email] = {
                      'firstName': _nameController.text,
                      'lastName': _lastNameController.text,
                      'email': widget.email,
                      'phone': _phoneController.text,
                      'sex': _sex,
                      'age': int.parse(_ageController.text),
                      'reasonForVisit': _reasonForVisit,
                      'reasonDescription': _reasonDescriptionController.text,
                      'durationOfIssue': _durationOfIssue,
                      'progression': _progression,
                      'isFirstTime': _isFirstTime,
                      'mainSymptom': _mainSymptomController.text,
                      'relatedSymptoms': _relatedSymptomsController.text,
                      'chronicConditions': _chronicConditionsController.text,
                      'currentMedications': _currentMedicationsController.text,
                      'allergies': _allergies,
                      'recentTests': _recentTestsController.text,
                      'recentTestsNotes': _recentTestsNotesController.text,
                      'perceivedSeverity': _perceivedSeverity,
                      'thoughtAboutER': _thoughtAboutER,
                      'whatHelped': _whatHelpedController.text,
                      'whatDoYouExpect': _whatDoYouExpect,
                    };

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

