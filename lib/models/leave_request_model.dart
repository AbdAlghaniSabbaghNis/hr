class LeaveRequest {
  final String id;
  final String employeeId;
  final LeaveType type; 
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
    LeaveStatus status; 


  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.type,
    required this.reason,
    required this.startDate,
    required this.status,
    required this.endDate,
  });
}

enum LeaveType {
  annual,
  sick,
  casual,
  maternity,
  paternity,
  bereavement,
  unpaid,
}
enum LeaveStatus { pending, approved, rejected }
