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
                  onPressed: _updateMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800], // Dark green button
                  ),
                  child: const Text('Update Meal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
