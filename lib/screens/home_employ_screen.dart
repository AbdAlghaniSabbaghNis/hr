import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controllers/employee_controller.dart';
import '../tools/app_routes_names_and_paths.dart';

class HomeEmployScreen extends StatelessWidget {
  const HomeEmployScreen({super.key});

  final List<Color> _blueShades = const [
    Color(0xFFBBDEFB),
    Color(0xFF90CAF9),
    Color(0xFF64B5F6),
    Color(0xFF42A5F5),
    Color(0xFF2196F3),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Employ home'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.employees.length,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          itemBuilder: (context, index) {
            final employee = controller.employees[index];
            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      controller.selectedEmployee = employee;

                      context.goNamed(
                        AppRoutesNamesAndPaths.editEmployeeScreen,
                      );
                    },

                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      controller.selectedEmployee = employee;

                      context.goNamed(
                        AppRoutesNamesAndPaths.leaveRequestFormScreen,
                      );
                    },
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    icon: Icons.event_note,
                    label: 'Request Leave',
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      controller.selectedEmployee = employee;

                      context.goNamed(
                        AppRoutesNamesAndPaths.leaveAttendanceScreen,
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.check_circle,
                    label: 'Attendance',
                  ),
                  SlidableAction(
                    onPressed: (_) => controller.deleteEmployee(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 5.0,
                ),
                color: _blueShades[index % _blueShades.length],
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.person, color: Colors.blueAccent),
                  ),
                  title: Text(
                    employee.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.jobTitle,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        employee.department,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.goNamed(AppRoutesNamesAndPaths.addEmployeeScreen),
        tooltip: 'Add Employee',
        child: const Icon(Icons.add),
      ),
    );
  }
}
