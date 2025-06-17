import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/leave_attendance_controller.dart';
import '../models/leave_request_model.dart';

class LeaveAttendanceScreen extends StatelessWidget {
  final controller = Get.put(LeaveAttendanceController());

  LeaveAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave & Attendance'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// قسم الموظفين
              ...controller.employees.map((employee) {
                final leaveRequests = employee.leaveRequests;
                final records =
                    controller.attendanceRecords
                        .where((r) => r.employeeId == employee.id.toString())
                        .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// --- قسم طلبات الإجازة ---
                    Text(
                      'Leave Requests - ${employee.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (leaveRequests.isEmpty)
                      const Center(child: Text('No leave requests found.'))
                    else
                      ...leaveRequests.map(
                        (leave) => LeaveRequestCard(
                          leave: leave,
                          controller: controller,
                        ),
                      ),
                    const SizedBox(height: 24),

                    /// --- قسم الحضور ---
                    Text(
                      'Employee Attendance - ${employee.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${employee.jobTitle} • ${employee.department}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Attendance Records:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (records.isEmpty)
                              const Text(
                                'No attendance records.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            else
                              ...records.map((r) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd MMM').format(r.date),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'In: ${r.clockIn != null ? DateFormat('hh:mm a').format(r.clockIn!) : 'N/A'}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Out: ${r.clockOut != null ? DateFormat('hh:mm a').format(r.clockOut!) : 'N/A'}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),
                  ],
                );
              }),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final newLeave = LeaveRequest(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            employeeId: '1',
            type: LeaveType.annual,
            reason: 'Vacation',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 3)),
            status: LeaveStatus.pending,
          );
          controller.submitLeave(newLeave);
          Get.snackbar(
            'Success',
            'Leave request submitted.',
            backgroundColor: Colors.teal.shade100,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Leave'),
      ),
    );
  }
}

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest leave;
  final LeaveAttendanceController controller;

  const LeaveRequestCard({
    super.key,
    required this.leave,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final employee = controller.getEmployeeById(leave.employeeId);

    final attendanceDuringLeave =
        controller.attendanceRecords
            .where(
              (record) =>
                  record.employeeId == leave.employeeId &&
                  record.date.isAfter(
                    leave.startDate.subtract(const Duration(days: 1)),
                  ) &&
                  record.date.isBefore(
                    leave.endDate.add(const Duration(days: 1)),
                  ),
            )
            .toList();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${leave.type.name.capitalizeFirst!} Leave',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  leave.status.name.capitalizeFirst!,
                  style: TextStyle(
                    color: _getStatusColor(leave.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            if (employee != null) ...[
              Text(
                '${employee.name} • ${employee.department}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                employee.jobTitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],

            const SizedBox(height: 6),

            Text(
              'From: ${DateFormat('dd MMM yyyy').format(leave.startDate)} → ${DateFormat('dd MMM yyyy').format(leave.endDate)}',
            ),

            if (leave.reason.isNotEmpty)
              Text(
                'Reason: ${leave.reason}',
                style: const TextStyle(fontSize: 13),
              ),

            const SizedBox(height: 10),

            if (attendanceDuringLeave.isNotEmpty) ...[
              const Text(
                'Attendance During Leave:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...attendanceDuringLeave.map(
                (record) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM').format(record.date),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'In: ${record.clockIn != null ? DateFormat('hh:mm a').format(record.clockIn!) : 'N/A'}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Out: ${record.clockOut != null ? DateFormat('hh:mm a').format(record.clockOut!) : 'N/A'}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const Text(
                'No attendance during leave period.',
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),

            const SizedBox(height: 10),

            if (leave.status == LeaveStatus.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => controller.approveLeave(leave.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => controller.rejectLeave(leave.id),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
