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
        return CustomRecipesPage(objectId: widget.objectId);
      case 4:
        return CalendarPage(scheduledRecipes: _calendarRecipes);
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Container(
      color: Colors.black, // Black background for the entire page
      constraints:
          BoxConstraints.expand(), // Make the container fill the screen
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.name}!',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'This app helps you track your calorie intake and meals throughout the day, '
              'so you can meet your dietary goals effectively.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white),
            const SizedBox(height: 20),
            _buildFeatureSection(
              icon: Icons.fastfood,
              title: 'Food Log',
              description:
                  'Log the meals you eat throughout the day. Track their calorie content to monitor your daily intake.',
            ),
            const SizedBox(height: 20),
            _buildFeatureSection(
              icon: Icons.receipt,
              title: 'Custom Recipes',
              description:
                  'Create custom recipes, calculate their total calories, and save them for future use.',
            ),
            const SizedBox(height: 20),
            _buildFeatureSection(
              icon: Icons.account_circle,
              title: 'Account',
              description:
                  'View and update your personal information or dietary preferences.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: Colors.green[800]),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: _buildPage(),
      ),
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
