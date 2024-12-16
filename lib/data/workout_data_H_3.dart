import 'package:flutter/material.dart';
import 'package:workoutassistant/datetime/date_time.dart';
import 'package:workoutassistant/models/exercise.dart';
import '../models/workout.dart';
import 'hive_database_H_3.dart';

class WorkoutDataH3 extends ChangeNotifier {

  final db = HiveDBH3();

  List<Workout> workoutList = [
    Workout(
      name: "Full Body Day 1",
      exercises: [
        Exercise(name: "Incline Pushups", 
        reps: "10", 
        sets: "2",
        ),
        Exercise(name: "Triangle Pushups", 
        reps: "10", 
        sets: "2",
        ),
        Exercise(name: "Squats", 
        reps: "15", 
        sets: "3",
        ),
        Exercise(name: "Forward Lunges", 
        reps: "10", 
        sets: "3",
        ),
        Exercise(name: "Floor IYT Raises", 
        reps: "10", 
        sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Full Body Day 2",
      exercises: [
        Exercise(name: "Jump Squats",
        reps: "10",
        sets: "1",
        ),
        Exercise(name: "Bicep Leg Curl",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "Mountain Climbers",
        reps: "10",
        sets: "1",
        ),
        Exercise(name: "Pushups",
        reps: "12-10",
        sets: "3",
        ),
        Exercise(name: "Leg Raises",
        reps: "8",
        sets: "2",
        ),
      ],
    ),
    Workout(
      name: "Full Body Day 3",
      exercises: [
        Exercise(name: "Sumo Squats",
        reps: "12",
        sets: "3",
        ),
        Exercise(name: "Pike Pushup",
        reps: "8",
        sets: "3",
        ),
        Exercise(name: "Plank Row",
        reps: "10",
        sets: "1",
        ),
        Exercise(name: "Chair Dips",
        reps: "10",
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