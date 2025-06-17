import 'package:flutter/material.dart';
import 'package:hr/controllers/employee_controller.dart';

import 'package:get/get.dart';

import 'tools/app_go_router.dart';

void main() {
  Get.put(EmployeeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerDelegate: AppGoRouter.router.routerDelegate,
      backButtonDispatcher: AppGoRouter.router.backButtonDispatcher,
      routeInformationProvider: AppGoRouter.router.routeInformationProvider,
      routeInformationParser: AppGoRouter.router.routeInformationParser,

    );
  }
}
