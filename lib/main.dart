import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pumpkin/theme.dart';
import 'package:pumpkin/utils/app_environment.dart';
import 'package:pumpkin/utils/screen_routes.dart';
import 'package:pumpkin/utils/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await dotenv.load(
      fileName:
          AppEnvironment.fileName); //Loading the environment variable file
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppLabels.appName,
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
      initialRoute: initialScreen,
      getPages: NavigationRoutes.routes,
    );
  }
}
