import 'package:get/get.dart';
import 'package:hr/models/attendance_record_model.dart';
import 'package:hr/models/employee.dart';
import 'package:hr/models/leave_request_model.dart';

class LeaveAttendanceController extends GetxController {
  var leaveRequests = <LeaveRequest>[].obs;
  var attendanceRecords = <AttendanceRecord>[].obs;
  var employees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    final now = DateTime.now();

    final dummyAttendance = [
      AttendanceRecord(
        id: 'att_1',
        employeeId: '1',
        date: DateTime(now.year, now.month, 1),
        clockIn: DateTime(now.year, now.month, 1, 8, 0),
        clockOut: DateTime(now.year, now.month, 1, 16, 0),
      ),
      AttendanceRecord(
        id: 'att_2',
        employeeId: '1',
        date: DateTime(now.year, now.month, 2),
        clockIn: DateTime(now.year, now.month, 2, 8, 30),
        clockOut: DateTime(now.year, now.month, 2, 15, 45),
      ),
      AttendanceRecord(
        id: 'att_3',
        employeeId: '1',
        date: DateTime(now.year, now.month, 3),
        clockIn: DateTime(now.year, now.month, 3, 9, 0),
        clockOut: DateTime(now.year, now.month, 3, 17, 0),
      ),
    ];

    final dummyLeavesRequests = [
      LeaveRequest(
        id: 'leave_1',
        employeeId: '1',
        startDate: DateTime(now.year, now.month, 5),
        endDate: DateTime(now.year, now.month, 7),
        reason: 'Medical leave',
        status: LeaveStatus.pending,
        type: LeaveType.sick,
      ),
      LeaveRequest(
        id: 'leave_2',
        employeeId: '1',
        startDate: DateTime(now.year, now.month, 10),
        endDate: DateTime(now.year, now.month, 12),
        reason: 'Family emergency',
        status: LeaveStatus.pending,
        type: LeaveType.casual,
      ),
    ];

    attendanceRecords.addAll(dummyAttendance);

    employees.add(
      Employee(
        id: 1,
        name: "Ahmed Ali",
        contact: "0123456789",
        department: "IT",
        jobTitle: "Flutter Developer",
        salary: 8000,
        role: "Developer",
        idDocumentPath: "assets/docs/id_ahmed.pdf",
        contractDocumentPath: "assets/docs/contract_ahmed.pdf",
        attendanceRecords: dummyAttendance,
        leaveRequests: dummyLeavesRequests,
      ),
    );
  }

  void submitLeave(LeaveRequest request) {
    leaveRequests.add(request);
  }

  Employee? getEmployeeById(String employeeId) {
    return employees.firstWhereOrNull((e) => e.id.toString() == employeeId);
  }

  void approveLeave(String id) {
    final leave = leaveRequests.firstWhere((r) => r.id == id);
    leave.status = LeaveStatus.approved;
    update();
  }

  void rejectLeave(String id) {
    final leave = leaveRequests.firstWhere((r) => r.id == id);
    leave.status = LeaveStatus.rejected;
    update();
  }

  void clockIn(String employeeId) {
    final today = DateTime.now();
    final id = '${employeeId}_${today.toIso8601String()}';
    final record = AttendanceRecord(
      id: id,
      employeeId: employeeId,
      date: today,
      clockIn: DateTime.now(),
    );
    attendanceRecords.add(record);

    final employee = employees.firstWhereOrNull(
      (e) => e.id.toString() == employeeId,
    );
    if (employee != null) {
      employee.attendanceRecords.add(record);
    }
  }

  void clockOut(String employeeId) {
    final today = DateTime.now();
    final record = attendanceRecords.lastWhere(
      (r) => r.employeeId == employeeId && r.date.day == today.day,
      orElse: () => throw 'Not clocked in',
    );
    record.clockOut = DateTime.now();
    update();
  }

  List<AttendanceRecord> getMonthlyReport(
    String employeeId,
    int year,
    int month,
  ) {
    return attendanceRecords
        .where(
          (r) =>
              r.employeeId == employeeId &&
              r.date.year == year &&
              r.date.month == month,
        )
        .toList();
  }
}
