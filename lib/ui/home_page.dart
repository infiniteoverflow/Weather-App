import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather_app/models/city_data.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadCityData(),
          builder: (context,snapshot) {
            if(snapshot.hasData) {
              return Text(snapshot.data.long.toString());
            }
            else {
              return CircularProgressIndicator();
            }
          },
        )
      ),
    );
  }

  Future<CityData> loadCityData() async {
    final Response response = await get(Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?q=bangalore&appid=2281dd56bcf28a0895bcc81251ef8c52"));
    if(response.statusCode == 200) {
      return CityData.fromJson(json.decode(response.body));
    }
  }
}
