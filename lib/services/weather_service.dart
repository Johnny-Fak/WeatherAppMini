import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse("$BASE_URL?q=$cityName&appid=$apikey&units=metric"));

    // final response = await http
    //     .get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}"));


    if (response.statusCode == 200) {
      // print(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city  = placemarks[0].locality;

    return city ?? "";
  }
}
