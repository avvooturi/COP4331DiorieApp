import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateMealPage extends StatefulWidget {
  final Map<String, dynamic> meal;

  const UpdateMealPage({Key? key, required this.meal}) : super(key: key);

  @override
  State<UpdateMealPage> createState() => _UpdateMealPageState();
}

class _UpdateMealPageState extends State<UpdateMealPage> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.meal['name'];
    _caloriesController.text = widget.meal['cal'].toString();
    _fatController.text = widget.meal['fat'].toString();
    _proteinController.text = widget.meal['prot'].toString();
    _carbsController.text = widget.meal['carb'].toString();
  }

  Future<void> _updateMeal() async {
    final updatedMeal = {
      'name': _nameController.text,
      'cal': int.parse(_caloriesController.text),
      'carb': int.parse(_carbsController.text),
      'prot': int.parse(_proteinController.text),
      'fat': int.parse(_fatController.text),
    };

    try {
      final mealId = widget.meal['_id']; // Use _id instead of id
      if (mealId == null || mealId.isEmpty) {
        print('Invalid Meal ID: $mealId');
        return;
      }

      final response = await http.put(
        Uri.parse('http://cop4331-t23.xyz:5079/api/updatemeal/$mealId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedMeal),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          Navigator.pop(context, jsonResponse['meal']);
        } else {
          print('Failed to update meal: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to update meal: ${response.body}');
      }
    } catch (error) {
      print('Error updating meal: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Meal'),
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
              onPressed: _updateMeal,
              child: const Text('Update Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
