import 'package:flutter/material.dart';
import 'package:workoutassistant/pages/calorie_calculator.dart';
import 'package:workoutassistant/pages/protein_calculator.dart';
import 'package:workoutassistant/pages/schedule_page_G.dart';
import 'package:workoutassistant/pages/schedule_page_H.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Assistant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250, 
              height: 60, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchedulePageG()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20), 
                ),
                child: Text('Gym Workout'),
              ),
            ),
            
            SizedBox(height: 16),
            
            SizedBox(
              width: 250, 
              height: 60, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchedulePageH()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20), 
                ),
                child: Text('Home Workout'),
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: 250, 
              height: 60, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProteinCalc()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20), 
                ),
                child: Text('Protein Calculator'),
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: 250, 
              height: 60, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalorieCalc()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20), 
                ),
                child: Text('Calorie Calculator'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}