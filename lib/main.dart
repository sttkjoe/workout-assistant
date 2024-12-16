import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:workoutassistant/data/workout_data_G_3.dart';
import 'package:workoutassistant/data/workout_data_G_5.dart';
import 'package:workoutassistant/data/workout_data_H_3.dart';
import 'package:workoutassistant/data/workout_data_H_5.dart';
import 'package:workoutassistant/pages/startpage.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("workoutassistant_db1");
  await Hive.openBox("workoutassistant_db2.1");
  await Hive.openBox("workoutassistant_db3");
  await Hive.openBox("workoutassistant_db4");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutDataG5()),
        ChangeNotifierProvider(create: (_) => WorkoutDataG3()),
        ChangeNotifierProvider(create: (_) => WorkoutDataH3()),
        ChangeNotifierProvider(create: (_) => WorkoutDataH5()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

   @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

