import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutassistant/components/heat_map.dart';
import 'package:workoutassistant/pages/workout_page_H_5.dart';
import '../data/workout_data_H_5.dart';

class HomePageH5 extends StatefulWidget {
  const HomePageH5 ({super.key});

  @override
  State<HomePageH5> createState() => _HomePageH5State();
}

class _HomePageH5State extends State<HomePageH5> {

   @override
  void initState() {
    super.initState();

    Provider.of<WorkoutDataH5>(context, listen: false).initWorkoutList();
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPageH5(workoutName: workoutName)));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutDataH5>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }
  
  void removeWorkout(String workoutName) {
    Provider.of<WorkoutDataH5>(context, listen: false).removeWorkout(workoutName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutDataH5>(builder: (context, value, child) => Scaffold(
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