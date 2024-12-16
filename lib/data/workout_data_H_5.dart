import 'package:flutter/material.dart';
import 'package:workoutassistant/datetime/date_time.dart';
import 'package:workoutassistant/models/exercise.dart';
import '../models/workout.dart';
import 'hive_database_H_5.dart';

class WorkoutDataH5 extends ChangeNotifier {

  final db = HiveDBH5();

  List<Workout> workoutList = [
    Workout(
      name: "Upper Body A",
      exercises: [
        Exercise(name: "Pike Push Ups", 
        reps: "10", 
        sets: "2",
        ),
        Exercise(name: "Floor Tricep Dip", 
        reps: "12", 
        sets: "3",
        ),
        Exercise(name: "Push Ups", 
        reps: "12", 
        sets: "3",
        ),
        Exercise(name: "Reverse Snow Angel", 
        reps: "12", 
        sets: "3",
        ),
        Exercise(name: "T Push Ups", 
        reps: "12", 
        sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "Jump Squats",
        reps: "10",
        sets: "2",
        ),
        Exercise(name: "Calf Raise",
        reps: "12",
        sets: "4",
        ),
        Exercise(name: "Forward Lunges",
        reps: "12",
        sets: "3",
        ),
        Exercise(name: "Squat To Alternate Kick Backs",
        reps: "10",
        sets: "2",
        ),
      ],
    ),
    Workout(
      name: "Core",
      exercises: [
        Exercise(name: "Suitcase Crunch",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "Leg Raise Side-To-Side",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "Alternating Superman",
        reps: "10",
        sets: "2",
        ),
        Exercise(name: "Tuck Crunches",
        reps: "10",
        sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Upper Body B",
      exercises: [
        Exercise(name: "Body Up",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "Hand Release Push Up",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "T Push Up",
        reps: "10-8",
        sets: "2",
        ),
        Exercise(name: "Reverse Snow Angel",
        reps: "12",
        sets: "3",
        ),
        Exercise(name: "Floor Tricep Dip",
        reps: "12",
        sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Full Body & Core",
      exercises: [
        Exercise(name: "Burpees",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "Squat",
        reps: "12",
        sets: "3",
        ),
        Exercise(name: "Leg Raise Side-To-Side",
        reps: "10",
        sets: "3",
        ),
        Exercise(name: "Side Leg Lateral Raise",
        reps: "10",
        sets: "2",
        ),
        Exercise(name: "V-Sit Crunches",
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