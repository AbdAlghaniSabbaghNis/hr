import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hr/screens/LeaveRequestFormScreen.dart';
import 'package:hr/screens/add_employee_screen.dart';

import '../screens/edit_employee_screen.dart';
import '../screens/home_employ_screen.dart';
import '../screens/leave_attendance_screen.dart';
import '../screens/page_not_found.dart';
import 'app_routes_names_and_paths.dart';

class AppGoRouter {
  static final router = GoRouter(
    navigatorKey: Get.key,
    debugLogDiagnostics: true,
    initialLocation: AppRoutesNamesAndPaths.homeEmployPath,
    errorBuilder: (context, state) => const PageNotFoundScreen(),
    redirect: (context, state) => null,
    routes: [
      GoRoute(
        path: AppRoutesNamesAndPaths.homeEmployPath,
        name: AppRoutesNamesAndPaths.homeEmployScreen,
        builder: (context, state) => HomeEmployScreen(),
        routes: [
          GoRoute(
            path: AppRoutesNamesAndPaths.editEmployeePath,
            name: AppRoutesNamesAndPaths.editEmployeeScreen,
            builder: (context, state) {
              return EditEmployeeScreen();
            },
          ),
          GoRoute(
            path: AppRoutesNamesAndPaths.addEmployeePath,
            name: AppRoutesNamesAndPaths.addEmployeeScreen,
            builder: (context, state) {
              return AddEmployeeScreen();
            },
          ),
          GoRoute(
            path: AppRoutesNamesAndPaths.leaverequestPath,
            name: AppRoutesNamesAndPaths.leaveRequestFormScreen,
            builder: (context, state) {
              return LeaveRequestFormScreen();
            },
          ),
           GoRoute(
            path: AppRoutesNamesAndPaths.leaveAttendancePath,
            name: AppRoutesNamesAndPaths.leaveAttendanceScreen,
            builder: (context, state) {
              return LeaveAttendanceScreen();
            },
          ),
        ],
      ),
    ],
  );
}
