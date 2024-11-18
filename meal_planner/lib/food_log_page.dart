import 'package:flutter/material.dart';
import 'add_meal_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodLogPage extends StatefulWidget {
  final List<Map<String, dynamic>> meals;
  final String objectId;

  const FoodLogPage({Key? key, required this.meals, required this.objectId});

  @override
  State<FoodLogPage> createState() => _FoodLogPageState();
}

class _FoodLogPageState extends State<FoodLogPage> {
  List<Map<String, dynamic>> displayedMeals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeals(); // Fetch all meals on initialization
  }

  Future<void> _fetchMeals({String? query}) async {
    final url = Uri.parse('http://cop4331-t23.xyz:5079/api/searchmeal')
        .replace(queryParameters: {
      'userId': widget.objectId,
      'search': query ?? '',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            displayedMeals =
                List<Map<String, dynamic>>.from(jsonResponse['meals'] ?? []);
          });
        } else {
          setState(() {
            displayedMeals = [];
          });
        }
      } else {
        print('Error fetching meals: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Meals',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _fetchMeals(query: _searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                _fetchMeals(query: value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedMeals.length,
              itemBuilder: (context, index) {
                final meal = displayedMeals[index];
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMealPage,
        tooltip: 'Add Meal',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToAddMealPage() async {
    final newMeal = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMealPage(userId: widget.objectId),
      ),
    );

    if (newMeal != null) {
      setState(() {
        displayedMeals.add(newMeal);
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
}
