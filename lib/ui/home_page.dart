import 'dart:convert';
import 'package:time_formatter/time_formatter.dart';

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
              return ListView(
                children: <Widget>[
                  Text("Coordinates : \nLat: ${snapshot.data.lat} Long: ${snapshot.data.long}"),
                
                  Text(
                    "Main : \nTemp ${kelvinToCelcius(snapshot.data.temp)} degree feels_like: ${kelvinToCelcius(snapshot.data.feelsLike)} degree\n"
                  ),

                  Text(
                    "Min Temp: ${kelvinToCelcius(snapshot.data.tempMin)} Max Temp: ${kelvinToCelcius(snapshot.data.tempMax)}\n"
                  ),

                  Text(
                    "Pressure: ${snapshot.data.pressure} Humidity: ${snapshot.data.humidity}\n"
                  ),

                  Text(
                    "Visibility: ${snapshot.data.visibility}\n"
                  ),

                  Text(
                    "Wind Speed: ${snapshot.data.windSpeed}\n"
                  ),

                  Text(
                    "Sunrise : ${timestampToTime(snapshot.data.sunrise)} , Sunset : ${timestampToTime(snapshot.data.sunset)}\n"
                  ),

                  Text(
                    "Country : ${snapshot.data.country} City : ${snapshot.data.cityName}",
                  ),

                  weatherData(snapshot.data.weatherList.weathers),

                ],
              );
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
    final Response response = await get(Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?q=california&appid=2281dd56bcf28a0895bcc81251ef8c52"));
    if(response.statusCode == 200) {
      return CityData.fromJson(json.decode(response.body));
    }
  }

  Widget weatherData(List weathers) {
    int len = weathers.length;
    String mainConditions = " ";
    String descriptions = " ";

    for(int i=0;i<len;i++) {
      mainConditions += "${weathers[i].main},";
      descriptions += "${weathers[i].description},";
    }

    return Text(mainConditions+descriptions);
  }

  int kelvinToCelcius(double kelvin) {
    return (kelvin - 273.15).round();
  }

  String timestampToTime(int timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var hour = date.toUtc().toLocal().hour;
    var min = date.toUtc().toLocal().minute;
    var minString = min.toString();
    var meridiem = "AM";

    if(hour>11) {
      meridiem = "PM";
    }
    if(min<10) {
      minString = "0$min";
    }
    return "$hour:$minString $meridiem IST";
  }
}
