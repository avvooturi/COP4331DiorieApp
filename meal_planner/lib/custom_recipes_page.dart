import 'package:flutter/material.dart';

class CustomRecipesPage extends StatefulWidget {
  const CustomRecipesPage({Key? key}) : super(key: key);

  @override
  _CustomRecipesPageState createState() => _CustomRecipesPageState();
}

class _CustomRecipesPageState extends State<CustomRecipesPage> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  void _submitData() {
    if (_caloriesController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    final data = {
      'calories': double.tryParse(_caloriesController.text) ?? 0.0,
      'protein': double.tryParse(_proteinController.text) ?? 0.0,
      'carbs': double.tryParse(_carbsController.text) ?? 0.0,
      'fat': double.tryParse(_fatController.text) ?? 0.0,
    };

    // Print data for now, replace with API call or database storage
    print('User data submitted: $data');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data successfully submitted!')),
    );

    // Clear the fields after submission
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Nutrient Intake'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _caloriesController,
              decoration:
                  const InputDecoration(labelText: 'Calories Consumed Today'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _proteinController,
              decoration: const InputDecoration(
                  labelText: 'Protein (g) Consumed Today'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _carbsController,
              decoration:
                  const InputDecoration(labelText: 'Carbs (g) Consumed Today'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fatController,
              decoration:
                  const InputDecoration(labelText: 'Fat (g) Consumed Today'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitData,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
