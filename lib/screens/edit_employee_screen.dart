import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/employee_controller.dart';
import '../models/employee.dart';
import '../widgets/bordered_text_field.dart';

class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({super.key});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _departmentController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _salaryController;

  final RxString _selectedRole = ''.obs;

  late Employee employee;
  final controller = Get.find<EmployeeController>();

  @override
  void initState() {
    super.initState();
    final selected = controller.selectedEmployee;
    if (selected == null) {
      // في حال عدم وجود موظف محدد، نظهر رسالة خطأ ونعود للخلف.
      Future.microtask(() {
        Get.snackbar(
          'Error',
          'No employee selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
        );
        Get.back();
      });
    } else {
      employee = selected;
      _nameController = TextEditingController(text: employee.name);
      _contactController = TextEditingController(text: employee.contact);
      _departmentController = TextEditingController(text: employee.department);
      _jobTitleController = TextEditingController(text: employee.jobTitle);
      _salaryController =
          TextEditingController(text: employee.salary.toString());
      _selectedRole.value = employee.role;
    }
  }

  void _saveForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = Employee(
        id: employee.id,
        name: _nameController.text,
        contact: _contactController.text,
        department: _departmentController.text,
        jobTitle: _jobTitleController.text,
        salary: double.tryParse(_salaryController.text) ?? employee.salary,
        role: _selectedRole.value,
        idDocumentPath: employee.idDocumentPath,
        contractDocumentPath: employee.contractDocumentPath,
      );

      await controller.editEmployee(employee, updatedEmployee);
      Get.snackbar(
        'Success',
        'Employee details updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      // يمكنك استخدام Get.back() بدلاً من context.pop() إذا كنت تستخدم GetX بالكامل.
      context.pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _departmentController.dispose();
    _jobTitleController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveForm(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.person,
                  size: 80.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20.0),
              BorderedTextField(
                labelText: 'Name',
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter employee name' : null,
              ),
              const SizedBox(height: 8.0),
              BorderedTextField(
                controller: _contactController,
                labelText: 'Contact',
                validator: (value) => value!.isEmpty
                    ? 'Please enter contact information'
                    : null,
              ),
              const SizedBox(height: 8.0),
              BorderedTextField(
                controller: _departmentController,
                labelText: 'Department',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter department' : null,
              ),
              const SizedBox(height: 8.0),
              BorderedTextField(
                controller: _jobTitleController,
                labelText: 'Job Title',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter job title' : null,
              ),
              const SizedBox(height: 8.0),
              BorderedTextField(
                controller: _salaryController,
                labelText: 'Salary',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: _selectedRole.value,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Employee', 'Manager', 'Supervisor']
                      .map(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _selectedRole.value = newValue;
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a role'
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _saveForm(context),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
