import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutassistant/components/heat_map.dart';
import '../data/workout_data_G_3.dart';
import 'workout_page_G_3.dart';

class HomePageG3 extends StatefulWidget {
  const HomePageG3 ({super.key});

  @override
  State<HomePageG3> createState() => _HomePageG3State();
}

class _HomePageG3State extends State<HomePageG3> {

  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutDataG3>(context, listen: false).initWorkoutList();
  }

  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Create New Workout"),
      content: TextField(controller: newWorkoutNameController),
      actions: [
        MaterialButton(
          onPressed: save, 
          child: Text("Save"),
          ),
        MaterialButton(
          onPressed: cancel, 
          child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPageG3(workoutName: workoutName)));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutDataG3>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }
  
  void removeWorkout(String workoutName) {
    Provider.of<WorkoutDataG3>(context, listen: false).removeWorkout(workoutName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutDataG3>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(
        title: const Text('Workout Assistant')),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout, 
          child: const Icon(Icons.add)),
        body: ListView(
          children: [
            //Heatmap
            MyHeatMap(datasets: value.heatMapDataset, startDateYYYYMMDD: value.getStartDate()),

            //Workout
            ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getWorkoutList().length, 
            itemBuilder: (context, index) => ListTile(
              title: Text(value.getWorkoutList()[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () => goToWorkoutPage(
                          value.getWorkoutList()[index].name)),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeWorkout(
                        value.getWorkoutList()[index].name),
                  ),
                ],
              ),
            )),
            ],
          )
  ));
  }
}