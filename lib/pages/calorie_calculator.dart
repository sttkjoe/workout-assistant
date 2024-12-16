import "package:flutter/material.dart";


class CalorieCalc extends StatefulWidget {
  const CalorieCalc({super.key});

  @override
  State<CalorieCalc> createState() => _CalorieCalcState();
}

class _CalorieCalcState extends State<CalorieCalc> {
 
  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  
  double calories = 0;
  String selectedGoal = 'lose';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calorie Calculator")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age (years)'),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight (kgs)'),
            ),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (cm)'),
            ),
            
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Select Goal: "),
                DropdownButton(value: selectedGoal, onChanged: (String? newValue){
                  setState(() {
                    selectedGoal = newValue ?? 'lose';
                  }
                  );
                },
                items: ['lose', 'gain'].map((String value) {
                  return DropdownMenuItem(value: value,
                    child: Text(value == 'lose' ? 'Lose Weight' : 'Gain Weight'),
                    );
                }
                ).toList(),
                )
              ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: calculateCalories,
                child: Text("Calculate")
                ),
              SizedBox(height: 20),
              Text('Recommended daily calorie intake to $selectedGoal 0.5% kgs per week: $calories',
              style: TextStyle(fontSize: 20))
          ],
        ),
        ),
    );
  
  }

  void calculateCalories() {
    int age = int.tryParse(_ageController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;

    // calculate BMR (basal metabolic rate)
    double bmr = 10 * weight + 6.25 * height - 5 * age + 5;

    // adjust BMR based on goal (lose or gain weight)
    if (selectedGoal == 'lose') {
      calories = bmr * 0.8; //20% calorie deficit
    } 
    else {
      calories = bmr * 1.2; //20% calorie surplus
    }

    setState(() {});
  }
}

