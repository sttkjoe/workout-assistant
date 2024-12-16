// ignore_for_file: unused_local_variable

import 'package:hive_flutter/hive_flutter.dart';
import 'package:workoutassistant/datetime/date_time.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDBH3 {

  final _hBox = Hive.box("workoutassistant_db3");

  bool isDataExistent() {
    if (_hBox.isEmpty) {
      print("previous data is non existent.");
      _hBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    }
    else {
      print("previous data exists.");
      return true;
    }
  }

  String getStartDate() {
  // check if the start date is available
  if (_hBox.containsKey("START_DATE")) {
    // if available, return the start date
    return _hBox.get("START_DATE");
  } else {
    // if not available, set the start date and return it
    String startDate = todaysDateYYYYMMDD();
    _hBox.put("START_DATE", startDate); // store the start date in the Hive box
    return startDate;
  }
}

  //save data in database
  void saveToDB(List<Workout> workouts) {
    final workoutList = convertWorkoutObjectToList(workouts);
    final exerciseList = convertExerciseObjectToList(workouts);

    if(exerciseCompleted(workouts)) {
      _hBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    }
    else {
      _hBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    _hBox.put("Workouts", workoutList);
    _hBox.put("Exercises", exerciseList);
  }

  List<Workout> readFromDB() {
    List<Workout> savedWorkouts = [];

    List<String> workoutNames = _hBox.get("Workouts");
    final exerciseDetails = _hBox.get("Exercises");

    for (int i=0; i<workoutNames.length; i++) {
      List<Exercise> exercisesPerWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesPerWorkout.add(Exercise(
          name: exerciseDetails[i][j][0], 
          reps: exerciseDetails[i][j][1], 
          sets: exerciseDetails[i][j][2],
          isCompleted: exerciseDetails[i][j][3] == "true" ? true : false));
      }

      Workout workout = Workout(name: workoutNames[i], exercises: exercisesPerWorkout);

      savedWorkouts.add(workout);
    }
    return savedWorkouts;
  }

  //check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for(var exercise in workout.exercises) {
        if(exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus (String yyyymmdd) {
    int completionStatus = _hBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

}

//converts workout objects into a list
List<String> convertWorkoutObjectToList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i<workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }
  return workoutList;
}

//converts the exercises into a list of strings so that it can be saved
List<List<List<String>>> convertExerciseObjectToList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i=0; i<workouts.length; i++) {

    List<Exercise> exercisesPerWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];

    for (int j=0; j < exercisesPerWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exercisesPerWorkout[j].name,
        exercisesPerWorkout[j].reps,
        exercisesPerWorkout[j].sets,
        exercisesPerWorkout[j].isCompleted.toString()
      ]);
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);

  }
  return exerciseList;
}
