import 'package:flutter/material.dart';
import 'package:workoutassistant/pages/home_page_G_3.dart';
import 'package:workoutassistant/pages/home_page_G_5.dart';

class SchedulePageG extends StatelessWidget {
  const SchedulePageG({Key? key});

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
                    MaterialPageRoute(builder: (context) => HomePageG3()),
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
                    MaterialPageRoute(builder: (context) => HomePageG5()),
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