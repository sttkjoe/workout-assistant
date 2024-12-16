import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workoutassistant/components/exercise_tile.dart';
import 'package:workoutassistant/data/workout_data_H_5.dart';

class WorkoutPageH5 extends StatefulWidget {
  final String workoutName;
  const WorkoutPageH5({super.key, required this.workoutName});

  @override
  State<WorkoutPageH5> createState() => _WorkoutPageH5State();
}

class _WorkoutPageH5State extends State<WorkoutPageH5> {

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutDataH5>(context, listen: false).
    checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();

  void createNewExercise() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Add a New Exercise"),
      content: Column(mainAxisSize: MainAxisSize.min,
        children: [
        TextField(controller: exerciseNameController, decoration: InputDecoration(labelText: 'Name')),
        TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets')),
        TextField(controller: repsController, decoration: InputDecoration(labelText: 'Reps'))
      ],),
      actions: [MaterialButton(
          onPressed: save, 
          child: Text("Save"),
          ),
        MaterialButton(
          onPressed: cancel, 
          child: Text("Cancel"),
          ),],
    ));
  }

  void save() {
    Provider.of<WorkoutDataH5>(context, listen: false).addExercise(
      widget.workoutName, exerciseNameController.text, repsController.text, setsController.text);

    Navigator.pop(context);
    exerciseNameController.clear();
    setsController.clear();
    repsController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    exerciseNameController.clear();
    setsController.clear();
    repsController.clear();
  }

  void removeExercise(String exerciseName) {
    Provider.of<WorkoutDataH5>(context, listen: false)
        .removeExercise(widget.workoutName, exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutDataH5>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(title: Text(widget.workoutName)),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewExercise,
        child: Icon(Icons.add),),
      body: ListView.builder(itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
      itemBuilder: (context, index) => ListTile( title: ExerciseTile(
        exerciseName: value.getRelevantWorkout(widget.workoutName).exercises[index].name, 
        reps: value.getRelevantWorkout(widget.workoutName).exercises[index].reps, 
        sets: value.getRelevantWorkout(widget.workoutName).exercises[index].sets, 
        isCompleted: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted,
         onCheckBoxChanged: (val) => onCheckBoxChanged(
          widget.workoutName, value.getRelevantWorkout(widget.workoutName).exercises[index].name)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
              onPressed: () => removeExercise(
                            value.getRelevantWorkout(widget.workoutName).exercises[index].name)
                      ))),
            ));
  }
}