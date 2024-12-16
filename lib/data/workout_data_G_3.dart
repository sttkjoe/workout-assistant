
import 'package:flutter/material.dart';
import 'package:workoutassistant/data/hive_database_G_3.dart';
import 'package:workoutassistant/datetime/date_time.dart';
import 'package:workoutassistant/models/exercise.dart';
import '../models/workout.dart';

class WorkoutDataG3 extends ChangeNotifier {
  
  final db = HiveDBG3();

  List<Workout> workoutList = [
    Workout(
      name: "Chest & Triceps",
      exercises: [
        Exercise(name: "Flat Bench Chest Press", 
        reps: "12-8", 
        sets: "3",
        ),
        Exercise(name: "Inclined Bench Chest Press", 
        reps: "12-8", 
        sets: "3",
        ),
        Exercise(name: "Cable Chest Flys", 
        reps: "12-10", 
        sets: "3",
        ),
        Exercise(name: "Cable Triceps Pushdown", 
        reps: "12-10", 
        sets: "3",
        ),
        Exercise(name: "Overhead Dumbbell Raises", 
        reps: "12-10", 
        sets: "3",
        ),
        Exercise(name: "Skullcrusher", 
        reps: "12-8", 
        sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Back & Biceps",
      exercises: [
        Exercise(name: "Lat Pulldowns",
        reps: "12-10",
        sets: "3",
        ),
        Exercise(name: "Seated Rows",
        reps: "12-10",
        sets: "3",
        ),
        Exercise(name: "Bent Over Dumbbell Rows",
        reps: "12-10",
        sets: "3",
        ),
        Exercise(name: "Preacher Curls Machine",
        reps: "10-8",
        sets: "3",
        ),
        Exercise(name: "Dumbbell Curls",
        reps: "10-8",
        sets: "3",
        ),
        Exercise(name: "Hammer Curls",
        reps: "10-8",
        sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Shoulders & Legs",
      exercises: [
        Exercise(name: "Leg Extensions",
        reps: "10-8",
        sets: "3",
        ),
        Exercise(name: "Hamstring Curls",
        reps: "10-8",
        sets: "3",
        ),
        Exercise(name: "Leg Press Machine",
        reps: "10-8",
        sets: "3",
        ),
        Exercise(name: "Calf Raises Machine",
        reps: "15-10",
        sets: "3",
        ),
        Exercise(name: "Dumbbell Shoulder Press ",
        reps: "12-8",
        sets: "3",
        ),
        Exercise(name: "Machine Lateral Shoulder Raises",
        reps: "12-8",
        sets: "3",
        ),
        Exercise(name: "Cable Rear Delt Flys",
        reps: "12-8",
        sets: "3",
        ),
      ],
    ),

  ];

  //if workouts in database, read workout list
  void initWorkoutList() {
    if (db.isDataExistent()) {
      workoutList = db.readFromDB();
    }
    // else use default workout list
    else {
      db.saveToDB(workoutList);
    }

    loadHeatMap();

  }

  // Get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();

    db.saveToDB(workoutList);
  }

  void removeWorkout(String workoutName) {
    workoutList.removeWhere((workout) => workout.name == workoutName);
    notifyListeners();

    db.saveToDB(workoutList);
  }

  void addExercise(String workoutName, String exerciseName, String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    
    relevantWorkout.exercises.add(Exercise(
      name: exerciseName, reps: reps, sets: sets));
      notifyListeners();

      db.saveToDB(workoutList);
  }

  void removeExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises
        .removeWhere((exercise) => exercise.name == exerciseName);
    notifyListeners();
    
    db.saveToDB(workoutList);
  }
  
  // Check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();

    db.saveToDB(workoutList);

    loadHeatMap();
  }
  
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    Exercise relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  String getStartDate() {
    return db.getStartDate();
}

  Map<DateTime, int> heatMapDataset = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    int betweenDays = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < betweenDays+1; i++) {
      String yyyymmdd = convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentagePerDay = <DateTime, int>{
        DateTime(year, month, day) : completionStatus};

      heatMapDataset.addEntries(percentagePerDay.entries);
    }
  }
}