import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = 'YOUR_API_KEY_HERE';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String _location = '';
  String _temperature = '';
  String _weatherDescription = '';
  String _weatherIcon = '';
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    // TODO: Implement getting the user's current location
    // You can use a location package like geolocator to fetch the user's location
    // and update the _location variable
    setState(() {
      _isLoading = true;
    });

    await _fetchWeatherData();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchWeatherData() async {
    try {
      // Fetch weather data from the API using the user's location
      var response = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?q=$_location&appid=$apiKey'
              as Uri);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _temperature = (data['main']['temp'] - 273.15).toStringAsFixed(1);
          _weatherDescription = data['weather'][0]['description'];
          _weatherIcon = data['weather'][0]['icon'];
          _hasError = false;
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  Widget _buildWeatherInfo() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else if (_hasError) {
      return const Text('Error fetching weather data');
    } else {
      return Column(
        children: [
          Text(
            _location,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Image.network('https://openweathermap.org/img/w/$_weatherIcon.png'),
          const SizedBox(height: 16),
          Text(
            'Temperature: $_temperature°C',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            'Weather: $_weatherDescription',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Weather App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: _buildWeatherInfo(),
          ),
        ),
      ),
    );
  }
}
