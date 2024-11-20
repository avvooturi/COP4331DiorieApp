import 'package:flutter/material.dart';

class AddMealPage extends StatefulWidget {
  final String userId;

  const AddMealPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _fatController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _submitMeal() {
    if (_nameController.text.isEmpty ||
        _caloriesController.text.isEmpty ||
        _fatController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _carbsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    final meal = {
      'userId': widget.userId,
      'name': _nameController.text,
      'cal': int.parse(_caloriesController.text),
      'carb': int.parse(_carbsController.text),
      'prot': int.parse(_proteinController.text),
      'fat': int.parse(_fatController.text),
    };

    Navigator.pop(context, meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Meal'),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        color: Colors.black, // Full black background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white), // White text
                decoration: const InputDecoration(
                  labelText: 'Meal Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _caloriesController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _fatController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Fat (g)',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _proteinController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Protein (g)',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _carbsController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Carbs (g)',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800], // Dark green button
                  ),
                  child: const Text('Add Meal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
