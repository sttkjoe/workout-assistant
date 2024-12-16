import 'package:flutter/material.dart';

class ProteinCalc extends StatefulWidget {
  const ProteinCalc({super.key});

  @override
  State<ProteinCalc> createState() => _ProteinCalcState();
}

class _ProteinCalcState extends State<ProteinCalc> {

  double? weight;
  double protein = 0.0;

   void calculateProtein() {
    setState(() {
      if (weight != null) {
        protein = weight! * 1.6;
      } 
      else {
        protein = 0.0;
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text('Protein Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your weight in kgs',
              ),
              onChanged: (value) {
                setState(() {
                  weight = double.tryParse(value);
                }
                );
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(onPressed: calculateProtein, child: Text('Calculate')),

            SizedBox(height: 20),

            Text('Protein intake per day: ${protein.toStringAsFixed(3)} grams', style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}