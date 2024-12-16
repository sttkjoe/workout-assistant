import 'package:flutter/material.dart';
import 'package:workoutassistant/pages/home_page_H_3.dart';
import 'package:workoutassistant/pages/home_page_H_5.dart';

class SchedulePageH extends StatelessWidget {
  const SchedulePageH({Key? key});

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
              width: 200, 
              height: 60, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageH3()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20), 
                ),
                child: Text('3 Day Schedule'),
              ),
            ),
            
            SizedBox(height: 16), 
            
            SizedBox(
              width: 200, 
              height: 60, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageH5()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('5 Day Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}