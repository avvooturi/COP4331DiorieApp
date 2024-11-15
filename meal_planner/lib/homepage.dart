// lib/homepage.dart

import 'package:flutter/material.dart';
import 'food_log_page.dart';
import 'custom_recipes_page.dart';
import 'calendar_page.dart';

class HomePage extends StatefulWidget {
  final String name;

  const HomePage({super.key, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _meals = [];
  final List<Map<String, dynamic>> _calendarRecipes = [];

  // Function to handle recipe added from CustomRecipesPage
  void _addRecipeToCalendar(Map<String, dynamic> recipe) {
    setState(() {
      _calendarRecipes.add(recipe);
    });
  }

  void _navigateToFoodLogPage() async {
    final newMeal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodLogPage(meals: _meals),
      ),
    );
    if (newMeal != null) {
      setState(() {
        _meals.add(newMeal); // Add the new meal to the _meals list
      });
    }
  }

  // Navigate to CustomRecipesPage
  void _navigateToCustomRecipesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomRecipesPage(
          onRecipeAdded: _addRecipeToCalendar,
        ),
      ),
    );
  }

  // Navigate to CalendarPage with scheduled recipes
  void _navigateToCalendarPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(scheduledRecipes: _calendarRecipes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hi ${widget.name}, please input the meals you eat into the food log!',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToFoodLogPage,
                child: const Text('Go to Food Log'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _navigateToCustomRecipesPage,
                child: const Text('Go to Custom Recipes'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _navigateToCalendarPage,
                child: const Text('View Recipe Calendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
