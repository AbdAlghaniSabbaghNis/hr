import 'package:get/get.dart';

import '../controllers/employee_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(EmployeeController());
  }
}
