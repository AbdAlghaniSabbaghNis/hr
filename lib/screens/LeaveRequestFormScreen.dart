import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../controllers/employee_controller.dart';
import '../controllers/leave_attendance_controller.dart';
import '../models/employee.dart';
import '../models/leave_request_model.dart';

class LeaveRequestFormScreen extends StatefulWidget {
  const LeaveRequestFormScreen({super.key});

  @override
  State<LeaveRequestFormScreen> createState() => _LeaveRequestFormScreenState();
}

class _LeaveRequestFormScreenState extends State<LeaveRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  final controller = Get.put(LeaveAttendanceController());
  final controllerEmployee = Get.find<EmployeeController>();

  Employee? employee;

  LeaveType? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;

  String? _startDateError;
  String? _endDateError;

  @override
  void initState() {
    super.initState();
    final selected = controllerEmployee.selectedEmployee;
    if (selected == null) {
      Get.snackbar(
        '❌ Error',
        'No employee selected',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) context.pop();
      });
    } else {
      employee = selected;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          _startDateError = null;
        } else {
          _endDate = date;
          _endDateError = null;
        }
      });
    }
  }

  void _submitForm() {
    setState(() {
      _startDateError = _startDate == null ? 'Please select start date' : null;
      _endDateError = _endDate == null ? 'Please select end date' : null;
    });

    if (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!)) {
      setState(() {
        _endDateError = 'End date must be after start date';
      });
      return;
    }

    if (_formKey.currentState!.validate() &&
        _startDateError == null &&
        _endDateError == null) {
      final newRequest = LeaveRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: employee!.id.toString(),
        type: _selectedType!,
        reason: _reasonController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        status: LeaveStatus.pending,
      );

      controller.submitLeave(newRequest);
      Get.back();
      Get.snackbar(
        '✅ Success',
        'Leave request submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (employee == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            '⚠️ No employee selected.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Leave Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.blue,
                child: Icon(Icons.event_note, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Name: ${employee!.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.apartment, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Department: ${employee!.department}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<LeaveType>(
                decoration: const InputDecoration(
                  labelText: 'Leave Type',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items:
                    LeaveType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name.capitalizeFirst!),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value);
                },
                validator:
                    (value) =>
                        value == null ? 'Please select leave type' : null,
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(
                      _startDate == null
                          ? 'Select Start Date'
                          : 'Start Date: ${formatDate(_startDate!)}',
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () => _pickDate(context, true),
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color:
                            _startDateError != null
                                ? Colors.red
                                : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  if (_startDateError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Text(
                        _startDateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(
                      _endDate == null
                          ? 'Select End Date'
                          : 'End Date: ${formatDate(_endDate!)}',
                    ),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () => _pickDate(context, false),
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color:
                            _endDateError != null
                                ? Colors.red
                                : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  if (_endDateError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Text(
                        _endDateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter reason' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Request'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
