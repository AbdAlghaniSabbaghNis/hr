class AttendanceRecord {
  final String id;
  final String employeeId;
  final DateTime date;
  DateTime? clockIn;
  DateTime? clockOut;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    this.clockIn,
    this.clockOut,
  });
}
