// lib/custom_recipes_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomRecipesPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onRecipeAdded;

  const CustomRecipesPage({Key? key, required this.onRecipeAdded})
      : super(key: key);

  @override
  _CustomRecipesPageState createState() => _CustomRecipesPageState();
}

class _CustomRecipesPageState extends State<CustomRecipesPage> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  DateTime? _selectedDate;
  final List<Map<String, dynamic>> _ingredients = [];
  final List<Map<String, dynamic>> _recipes = [];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addIngredient(String name, double calories) {
    setState(() {
      _ingredients.add({
        'name': name,
        'calories': calories,
      });
    });
  }

  void _addRecipe() {
    if (_recipeNameController.text.isEmpty || _selectedDate == null) {
      return;
    }

    final recipe = {
      'name': _recipeNameController.text,
      'ingredients': List<Map<String, dynamic>>.from(_ingredients),
      'servings': _servingsController.text,
      'date':
          _selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };

    setState(() {
      _recipes.add(recipe);
      _ingredients.clear(); // Clear ingredients for next recipe
    });

    widget.onRecipeAdded(recipe); // Add the recipe to the calendar

    // Clear fields after recipe is added
    _recipeNameController.clear();
    _servingsController.clear();
    _selectedDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _recipeNameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _servingsController,
              decoration: const InputDecoration(labelText: 'Servings'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 10),
            Text(
                'Selected Date: ${_selectedDate != null ? DateFormat.yMMMd().format(_selectedDate!) : 'None'}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addRecipe,
              child: const Text('Add Recipe'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return ListTile(
                    title: Text(recipe['name']),
                    subtitle: Text('Date: ${recipe['date']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
