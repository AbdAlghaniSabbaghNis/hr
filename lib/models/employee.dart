import 'package:equatable/equatable.dart';
import 'package:hr/models/leave_request_model.dart';
import 'attendance_record_model.dart'; 

class Employee extends Equatable {
  final int id;
  final String name;
  final String contact;
  final String department;
  final String jobTitle;
  final double salary;
  final String role;
  final String idDocumentPath;
  final String contractDocumentPath;
  final List<AttendanceRecord> attendanceRecords; 
    final List<LeaveRequest> leaveRequests; 



  const Employee({
    required this.id,
    required this.name,
    required this.contact,
    required this.department,
    required this.jobTitle,
    required this.salary,
    required this.role,
    required this.idDocumentPath,
    required this.contractDocumentPath,
    this.attendanceRecords = const [], 
    this.leaveRequests = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        contact,
        department,
        jobTitle,
        salary,
        role,
        idDocumentPath,
        contractDocumentPath,
        attendanceRecords, 
        leaveRequests,
      ];
}
