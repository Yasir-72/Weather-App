import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/modal/weathermodal.dart';
import 'package:weather_app/res/response.dart';
import 'package:weather_app/screens/infopage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  ForecastDay? forecastInfo;
  WeatherData? weatherInfo;
  bool isLoading = true;
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location when the app starts
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch weather data based on the current location
      _fetchWeatherDataFromLocation(position.latitude, position.longitude);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location permission denied. Please enable location."),
          backgroundColor: Colors.red,
        ),
      );
      // You can set a default location like "Mumbai" if location permission is denied
      _fetchWeatherData("Mumbai");
    }
  }

  Future<void> _fetchWeatherData(String cityName) async {
    setState(() {
      isLoading = true;
    });

    try {
      final weatherService = WeatherServices();
      final data = await weatherService.fetchWeather(cityName);
      setState(() {
        weatherInfo = data;
        isLoading = false;
        isSearchMode = false; // Revert to normal AppBar after search
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        weatherInfo = null;
        isSearchMode = false; // Revert to normal AppBar even on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error fetching weather data. Please try again.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchWeatherDataFromLocation(double latitude, double longitude) async {
    setState(() {
      isLoading = true;
    });

    try {
      final weatherService = WeatherServices();
      final data = await weatherService.fetchWeatherByCoordinates(latitude, longitude);
      setState(() {
        weatherInfo = data;
        isLoading = false;
        isSearchMode = false; // Revert to normal AppBar after fetching location data
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        weatherInfo = null;
        isSearchMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error fetching weather data. Please try again.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getDayName(String dateString) {
    final date = DateTime.parse(dateString);
    return [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06040F),
        title: Row(
          children: [
            if (!isSearchMode) 
              IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Infopage();
                    },
                  );
                },
                icon: Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            if (isSearchMode) 
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isSearchMode = false;
                  });
                },
              ),
            Expanded(
              child: isSearchMode
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter Location",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _fetchWeatherData(value.trim());
                          setState(() {
                            isSearchMode = false;
                          });
                        }
                      },
                    )
                  : Center(
                      child: Text(
                        "Weather Hub",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        actions: [
          if (!isSearchMode) 
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  isSearchMode = true;
                });
              },
            ),
        ],
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
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
        child: Stack(
          children: [
            // Content above DraggableScrollableSheet
            Center(
              child: Column(
                children: [
                  // Weather Icon and Temperature Section
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 10,
                      //     left: 20,
                      //     right: 20,
                      //   ),
                      //   child: Container(
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 20,
                      //       vertical: 10,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white.withOpacity(0.1),
                      //       borderRadius: BorderRadius.circular(25),
                      //     ),
                      //     child: TextField(
                      //       controller: _searchController,
                      //       style: const TextStyle(color: Colors.white),
                      //       decoration: InputDecoration(
                      //         hintText: "Enter Location",
                      //         hintStyle: const TextStyle(color: Colors.white70),
                      //         border: InputBorder.none,
                      //         suffixIcon: IconButton(
                      //           icon: const Icon(Icons.search,
                      //               color: Colors.white, size: 28),
                      //           onPressed: () {
                      //             final cityName =
                      //                 _searchController.text.trim();
                      //             if (cityName.isNotEmpty) {
                      //               _fetchWeatherData(cityName);
                      //             }
                      //           },
                      //         ),
                      //       ),
                      //       onSubmitted: (value) {
                      //         if (value.isNotEmpty) {
                      //           _fetchWeatherData(value.trim());
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                      Image.asset(
                        "images/mixcloud.png",
                        height: 200,
                      ),
                      Text(
                        weatherInfo != null
                            ? '${(weatherInfo!.temperature).toStringAsFixed(0)}\u00B0C'
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        weatherInfo != null
                            ? '${weatherInfo!.cityName}, ${weatherInfo!.country}'
                            : 'N/A',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: SizedBox(
                          height: 20,
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weatherInfo != null
                                          ? "Min: ${weatherInfo!.forecast[0].minTemp}\u00B0C"
                                          : "N/A",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      weatherInfo != null
                                          ? "Max: ${weatherInfo!.forecast[0].maxTemp}\u00B0C"
                                          : "N/A",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // House Image Section
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Image.asset(
                        "images/House.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF06040F),
                        Color(0xFF1B0E55),
                        Color(0xFF2D1583),
                        Color(0xFFA316D1),
                        Color(0xFFF675EB),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Text(
                          "Weather Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_pin,
                              color: Colors.white, size: 24),
                          Text(
                            weatherInfo != null
                                ? "${weatherInfo!.cityName}"
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 5,
                        color: Colors.white.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 200,
                          height: 130,
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: weatherInfo?.forecast
                                      .length, // Dynamic count based on forecast
                                  itemBuilder: (context, index) {
                                    final forecastDay =
                                        weatherInfo?.forecast[index];
                                    return Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Column(
                                        children: [
                                          Text(
                                            _getDayName(forecastDay!.date),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Icon(
                                            Icons
                                                .thermostat, // Replace with your weather condition icon logic
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${forecastDay.avgTemp}°C', // Display max temperature
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherCard(
                              "Condition",
                              weatherInfo != null
                                  ? '${(weatherInfo!.forecast[0].condition)}'
                                  : 'N/A',
                              Icons.sunny_snowing),
                          _buildWeatherCard(
                              "Wind",
                              weatherInfo != null
                                  ? '${(weatherInfo!.windSpeed).toStringAsFixed(2)}\ Km\h'
                                  : 'N/A',
                              Icons.air),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherCard(
                              "Humidity",
                              weatherInfo != null
                                  ? '${(weatherInfo!.humidity).toStringAsFixed(0)}\ %'
                                  : 'N/A',
                              Icons.water_drop),
                          _buildWeatherCard(
                              "Pressure",
                              weatherInfo != null
                                  ? '${(weatherInfo!.pressure.toStringAsFixed(0))}'
                                  : 'N/A',
                              Icons.speed),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherCard(
                              "UV",
                              weatherInfo != null
                                  ? '${(weatherInfo!.UV.toStringAsFixed(2))}'
                                  : 'N/A',
                              Icons.sunny_snowing),
                          _buildWeatherCard(
                              "Real Feel",
                              weatherInfo != null
                                  ? '${(weatherInfo!.realfeel).toStringAsFixed(2)}\u00B0C'
                                  : 'N/A',
                              Icons.line_weight),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      color: Colors.white.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
