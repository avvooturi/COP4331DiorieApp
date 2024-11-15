// lib/calendar_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<Map<String, dynamic>> scheduledRecipes;

  const CalendarPage({Key? key, required this.scheduledRecipes})
      : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<Map<String, dynamic>>> _recipesByDate = {};
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prepareRecipesByDate();
  }

  void _prepareRecipesByDate() {
    _recipesByDate.clear(); // Clear old entries
    for (var recipe in widget.scheduledRecipes) {
      final date = DateTime.parse(recipe['date']);
      _recipesByDate.putIfAbsent(date, () => []).add(recipe);
    }
  }

  List<Map<String, dynamic>> _getRecipesForSelectedDay() {
    return _recipesByDate[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Calendar')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2101, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _recipesByDate[day] ?? [],
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              // Customize how event dots are shown
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Display selected day's recipes
          Expanded(
            child: ListView(
              children: _getRecipesForSelectedDay().map((recipe) {
                return ListTile(
                  title: Text(recipe['name']),
                  subtitle: Text('Servings: ${recipe['servings']}'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
