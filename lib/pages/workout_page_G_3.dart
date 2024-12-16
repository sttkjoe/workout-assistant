import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:workoutassistant/components/exercise_tile.dart';
import 'package:workoutassistant/data/workout_data_G_3.dart';

class WorkoutPageG3 extends StatefulWidget {
  final String workoutName;
  const WorkoutPageG3({super.key, required this.workoutName});

  @override
  State<WorkoutPageG3> createState() => _WorkoutPageG3State();
}

class _WorkoutPageG3State extends State<WorkoutPageG3> {

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutDataG3>(context, listen: false).
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
    Provider.of<WorkoutDataG3>(context, listen: false).addExercise(
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
    Provider.of<WorkoutDataG3>(context, listen: false)
        .removeExercise(widget.workoutName, exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutDataG3>(builder: (context, value, child) => Scaffold(
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