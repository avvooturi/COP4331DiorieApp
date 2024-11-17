import 'package:flutter/material.dart';
import 'add_meal_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodLogPage extends StatefulWidget {
  final List<Map<String, dynamic>> meals;
  final String objectId; // Add this line

  const FoodLogPage(
      {super.key,
      required this.meals,
      required this.objectId}); // Update constructor

  @override
  State<FoodLogPage> createState() => _FoodLogPageState();
}

class _FoodLogPageState extends State<FoodLogPage> {
  List<Map<String, dynamic>> get meals => widget.meals;

  Future<void> _navigateToAddMealPage() async {
    final newMeal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddMealPage(userId: widget.objectId), // Pass objectId here
      ),
    );

    if (newMeal != null) {
      setState(() {
        meals.add(newMeal);
      });

      // Send meal to backend
      try {
        final response = await http.post(
          Uri.parse('http://cop4331-t23.xyz:5079/api/createmeal'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(newMeal),
        );

        if (response.statusCode == 201) {
          print('Meal successfully added to the database');
        } else {
          print('Failed to add meal to the database: ${response.body}');
        }
      } catch (error) {
        print('Error adding meal to the database: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return ListTile(
            title: Text(meal['name']),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(meal['name']),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Calories: ${meal['cal']}'),
                      Text('Fat: ${meal['fat']}g'),
                      Text('Protein: ${meal['prot']}g'),
                      Text('Carbs: ${meal['carb']}g'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMealPage,
        tooltip: 'Add Meal',
        child: const Icon(Icons.add),
      ),
    );
  }
}
