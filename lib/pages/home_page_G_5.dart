import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutassistant/components/heat_map.dart';
import '../data/workout_data_G_5.dart';
import 'workout_page_G_5.dart';

class HomePageG5 extends StatefulWidget {
  const HomePageG5 ({super.key});

  @override
  State<HomePageG5> createState() => _HomePageG5State();
}

class _HomePageG5State extends State<HomePageG5> {

   @override
  void initState() {
    super.initState();

    Provider.of<WorkoutDataG5>(context, listen: false).initWorkoutList();
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPageG5(workoutName: workoutName)));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutDataG5>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    newWorkoutNameController.clear();
  }
  
  void removeWorkout(String workoutName) {
    Provider.of<WorkoutDataG5>(context, listen: false).removeWorkout(workoutName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutDataG5>(builder: (context, value, child) => Scaffold(
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