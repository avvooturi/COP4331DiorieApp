import 'package:flutter/material.dart';
// import 'dart:convert';

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
        SnackBar(content: Text('All fields are required')),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Meal Name'),
            ),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fatController,
              decoration: const InputDecoration(labelText: 'Fat (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _proteinController,
              decoration: const InputDecoration(labelText: 'Protein (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _carbsController,
              decoration: const InputDecoration(labelText: 'Carbs (g)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitMeal,
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
