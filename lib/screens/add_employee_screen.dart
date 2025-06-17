import 'package:flutter/material.dart';

import '../widgets/bordered_text_field.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _departmentController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _salaryController = TextEditingController();
  String _selectedRole = 'Employee';

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _departmentController.dispose();
    _jobTitleController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the data
      final employeeData = {
        'name': _nameController.text,
        'contact': _contactController.text,
        'department': _departmentController.text,
        'jobTitle': _jobTitleController.text,
        'salary': double.tryParse(_salaryController.text) ?? 0.0,
        'role': _selectedRole,
      };
      print('Employee Data: $employeeData');
      // Here you would typically save the data
      // For now, just print and clear the form or navigate back
      _formKey.currentState!.reset();
      _nameController.clear();
      _contactController.clear();
      _departmentController.clear();
      _jobTitleController.clear();
      _salaryController.clear();
      setState(() {
        _selectedRole = 'Employee';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Employee'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Icon(Icons.person_add, size: 80.0, color: primaryColor),
              ),
              const SizedBox(height: 30.0),

              BorderedTextField(
                controller: _nameController,
                labelText: 'Name',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter employee name'
                            : null,
              ),
              const SizedBox(height: 16.0),
              BorderedTextField(
                controller: _contactController,
                labelText: 'Contact',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter contact information'
                            : null,
              ),
              const SizedBox(height: 16.0),
              BorderedTextField(
                controller: _departmentController,
                labelText: 'Department',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter department'
                            : null,
              ),
              const SizedBox(height: 16.0),
              BorderedTextField(
                controller: _jobTitleController,
                labelText: 'Job Title',
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter job title'
                      : null;
                },
              ),
              const SizedBox(height: 16.0),
              BorderedTextField(
                controller: _salaryController,
                labelText: 'Salary',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary';
                  }
                  return double.tryParse(value) == null
                      ? 'Please enter a valid number for salary'
                      : null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                  decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(), // Added border
                ),
                isExpanded: true,
                items:
                    <String>[
                      'Employee',
                      'Manager',
                      'Supervisor',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Employee'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
