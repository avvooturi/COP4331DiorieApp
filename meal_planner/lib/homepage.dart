// lib/homepage.dart

import 'package:flutter/material.dart';
import 'food_log_page.dart';
import 'custom_recipes_page.dart';
import 'calendar_page.dart';
import 'account.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String objectId;

  const HomePage({Key? key, required this.name, required this.objectId})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _meals = [];
  final List<Map<String, dynamic>> _calendarRecipes = [];

  void _addRecipeToCalendar(Map<String, dynamic> recipe) {
    setState(() {
      _calendarRecipes.add(recipe);
    });
  }

  void _navigateToFoodLogPage() async {
    final newMeal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodLogPage(
          meals: _meals,
          objectId: widget.objectId,
        ),
      ),
    );
    if (newMeal != null) {
      setState(() {
        _meals.add(newMeal);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return AccountPage(objectId: widget.objectId, name: widget.name);
      case 2:
        return FoodLogPage(meals: _meals, objectId: widget.objectId);
      case 3:
        return const CustomRecipesPage(); // No onRecipeAdded parameter
      case 4:
        return CalendarPage(scheduledRecipes: _calendarRecipes);
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Center(
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green, // Set this to make all items green
        onTap: _onItemTapped,
      ),
    );
  }
}
