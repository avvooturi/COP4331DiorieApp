import 'package:flutter/material.dart';
import 'add_meal_page.dart';

class FoodLogPage extends StatefulWidget {
  final List<Map<String, dynamic>> meals;

  const FoodLogPage({super.key, required this.meals});

  @override
  State<FoodLogPage> createState() => _FoodLogPageState();
}

class _FoodLogPageState extends State<FoodLogPage> {
  List<Map<String, dynamic>> get meals => widget.meals;

  Future<void> _navigateToAddMealPage() async {
    final newMeal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMealPage(),
      ),
    );
    if (newMeal != null) {
      Navigator.pop(context, newMeal); // Pass the meal back to HomePage
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
                      Text('Calories: ${meal['calories']}'),
                      Text('Fat: ${meal['fat']}g'),
                      Text('Protein: ${meal['protein']}g'),
                      Text('Carbs: ${meal['carbs']}g'),
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
