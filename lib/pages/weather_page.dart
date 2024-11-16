import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("eada4fcb19718771149fc0d484b19f62");

  Weather? _weather;
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      throw Exception();
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return ('assets/sunny.json');

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
      case 'dust':
        return ('assets/cloudy.json');
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return ('assets/rain.json');
      case 'thunderstorm':
        return ('assets/thunder.json');
      case 'clear':
        return ('assets/sunny.json');
      default:
        return ('assets/sunny.json');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    datetime();
  }

  int currentTime = DateTime.now().hour;
  datetime() async{
    if (currentTime > 7 && currentTime < 17) {
      color = Colors.white;
      textColor = Colors. black;
    } else {
      color = const Color.fromARGB(255, 20, 20, 20);
      textColor = Colors. grey;
    }
  }

  Color color = const Color.fromARGB(255, 20, 20, 20);
  Color textColor = const Color.fromARGB(255, 20, 20, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
      ),
      backgroundColor: color,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.location_on,
                    color: textColor,
                  ),
                  Text(
                    _weather?.cityName ?? "No City....",
                    style: TextStyle(
                      fontSize: 28,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Lottie.asset(
                  getWeatherAnimation(_weather?.mainCondition)),
              Text("${_weather?.temperature.round()}°",
                  style: TextStyle(
                      fontSize: 40,
                      color: textColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
