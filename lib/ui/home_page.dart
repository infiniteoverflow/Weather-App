import 'dart:convert';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
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

    String city = "jammu";

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadCityData(city),
          builder: (context,snapshot) {
            if(snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  // Text("Coordinates : \nLat: ${snapshot.data.lat} Long: ${snapshot.data.long}"),
                
                  // Text(
                  //   "Main : \nTemp ${kelvinToCelcius(snapshot.data.temp)} degree feels_like: ${kelvinToCelcius(snapshot.data.feelsLike)} degree\n"
                  // ),

                  // Text(
                  //   "Min Temp: ${kelvinToCelcius(snapshot.data.tempMin)} Max Temp: ${kelvinToCelcius(snapshot.data.tempMax)}\n"
                  // ),

                  // Text(
                  //   "Pressure: ${snapshot.data.pressure} Humidity: ${snapshot.data.humidity}\n"
                  // ),

                  // Text(
                  //   "Visibility: ${snapshot.data.visibility}\n"
                  // ),

                  // Text(
                  //   "Wind Speed: ${snapshot.data.windSpeed}\n"
                  // ),

                  // Text(
                  //   "Sunrise : ${timestampToTime(snapshot.data.sunrise)} , Sunset : ${timestampToTime(snapshot.data.sunset)}\n"
                  // ),

                  // Text(
                  //   "Country : ${snapshot.data.country} City : ${snapshot.data.cityName}",
                  // ),

                  // weatherData(snapshot.data.weatherList.weathers),

                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter City",
                        suffixIcon: Icon(Icons.search),
                        
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.1),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "City : ${snapshot.data.cityName},${snapshot.data.country}",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            height: MediaQuery.of(context).size.height*0.3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: getWeatherImage(snapshot.data.weatherList.weathers[0].iconID),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              "${snapshot.data.weatherList.weathers[0].main}",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Temp : ${kelvinToCelcius(snapshot.data.temp)}°C",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Feels Like : ${kelvinToCelcius(snapshot.data.feelsLike)}°C",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Image(image: AssetImage("assets/images/sun.png"),height: 50,),
                                Padding(padding: EdgeInsets.all(4)),
                                Text("Sunrise"),
                                Padding(padding: EdgeInsets.all(4)),
                                Text("${timestampToTime(snapshot.data.sunrise)}")
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Image(image: AssetImage("assets/images/sea.png"),height: 50,),
                                Padding(padding: EdgeInsets.all(4)),
                                Text("Sunset"),
                                Padding(padding: EdgeInsets.all(4)),
                                Text("${timestampToTime(snapshot.data.sunset)}")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

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

  Future<CityData> loadCityData(String city) async {
    final Response response = await get(Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=2281dd56bcf28a0895bcc81251ef8c52"));
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

  int kelvinToCelcius(var kelvin) {
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

  DecorationImage getWeatherImage(String condition) {
    int code = int.parse(condition.substring(0,2));
    var asset = " ";
    print(code);
    switch(code) {
      case 01: asset = "assets/images/sunny.png"; break;
      case 02: asset = "assets/images/few_cloud.png"; break;
      case 03: asset = "assets/images/scattered.png"; break;
      case 04: asset = "assets/images/black_clouds.png"; break;
      case 09: asset = "assets/images/shower.png"; break;
      case 10: asset = "assets/images/rain.png"; break;
      case 11: asset = "assets/images/thunder.png"; break;
      case 13: asset = "assets/images/snow.png"; break;
      case 50: asset = "assets/images/haze.png"; break;
    }
    return DecorationImage(image: AssetImage(asset));
  }
}
