import 'package:flutter/material.dart';
import 'package:weather_app/modal/weathermodal.dart';
import 'package:weather_app/res/response.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<WeatherData> _searchResults = [];
  bool _isLoading = false;

  // Function to search weather data for a city
  Future<void> _searchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weatherService = WeatherServices();
      // Fetch weather data based on city name
      WeatherData? data = await weatherService.fetchWeather(cityName);

      setState(() {
        if (data != null) {
          // Add the city to search results list
          _searchResults.add(data);
        } else {
          _searchResults = []; // Reset if no data found
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      print("Error fetching weather data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF06040F),
              Color(0xFF1B0E55),
              Color(0xFF2D1583),
              Color(0xFFA316D1),
              Color(0xFFF675EB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Search bar container
            Padding(
              padding:  EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 10),
              child: Container(
                width: double.infinity,
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter Location",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.white, size: 28),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _searchWeather(value); // Perform search
                    }
                  },
                ),
              ),
            ),
            
            // Display loading indicator if searching
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),

            // List items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Card(
                      color: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        title: Text(
                          _searchResults[index].cityName, // Display city name
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${_searchResults[index].temperature.toStringAsFixed(0)}°C', // Display temperature
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        leading: Icon(Icons.location_on, color: Colors.white),
                        trailing: Icon(Icons.add, color: Colors.white, size: 30),
                        onTap: () {
                          // Handle item tap if needed
                        },
                      ),
                    ),
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
