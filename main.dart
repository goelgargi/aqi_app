//import statements
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//-----------------------------------

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var c = "getting";
  Future<String> getdata() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lat = position.latitude;
    var lon = position.longitude;
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=23d30bfce8195ee08521e36c6bdfbee3');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      var parsedjson = jsonDecode(data);
      var aqi = parsedjson['list'][0]['main']['aqi'].toString();
      return aqi;
    } else {
      throw Exception("Failed to load air quality index");
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata(),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Color.fromARGB(255, 163, 196, 252),
              body: Center(
                  child: Column(
                children: <Widget>[
                  SizedBox(height: 300),
                  Text("The Aqi of your current location is:"),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Text(snapshot.data.toString()),
                  ),
                ],
              )));
        });
  }
}
