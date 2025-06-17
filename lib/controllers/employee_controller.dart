import 'package:get/get.dart';
import '../models/employee.dart';

class EmployeeController extends GetxController {
  var employees = <Employee>[].obs;
  Employee? selectedEmployee;

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  void loadEmployees() {
    employees.value = [
      Employee(
        id: 1,
        name: 'John Doe',
        contact: 'johndoe@example.com',
        department: 'IT',
        jobTitle: 'Software Engineer',
        salary: 60000.0,
        role: 'Employee',
        idDocumentPath: '',
        contractDocumentPath: '',
      ),
      Employee(
        id: 2,
        name: 'Jane Smith',
        contact: 'janesmith@example.com',
        department: 'HR',
        jobTitle: 'HR Manager',
        salary: 70000.0,
        role: 'Manager',
        idDocumentPath: '',
        contractDocumentPath: '',
      ),
    ];
  }

  void setSelectedEmployee(Employee employee) {
    selectedEmployee = employee;
    update(); 
  }

  void deleteEmployee(int index) {
    final deleted = employees.removeAt(index);
    Get.snackbar('Deleted', '${deleted.name} has been removed');
  }

  Future<void> editEmployee(Employee oldEmp, Employee updatedEmployee) async {
    final index = employees.indexWhere((e) => e.id == oldEmp.id);

    if (index != -1) {
      employees[index] = updatedEmployee;
      update();
    }
  }
}
