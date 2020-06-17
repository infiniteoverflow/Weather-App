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

  TextEditingController cityController = TextEditingController();
  String city = "bangalore";
  String previousCity = "bangalore";
  String API_KEY = "<Your API Key>";

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: FutureBuilder(
          future: loadCityData(city),
          builder: (context,snapshot) {
            if(snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter City",
                        suffixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                      keyboardType: TextInputType.text,
                      controller: cityController,
                      onSubmitted: (var value) {
                        setState(() {
                          previousCity = city;
                          city = value;
                        });
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width*0.3,
                        margin: EdgeInsets.only(left:10),
                        decoration: BoxDecoration(
                          image: getWeatherImage(snapshot.data.weatherList.weathers[0].iconID)
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text(
                                "${kelvinToCelcius(snapshot.data.temp)}°C",
                                style: TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Center(
                              child: Text(
                                "${snapshot.data.weatherList.weathers[0].main}",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top:20,right: 10,left: 10),
                      margin: EdgeInsets.only(top:10),
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${snapshot.data.cityName},${snapshot.data.country}",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                                Icon(
                                  Icons.location_city,
                                  color: Colors.grey,
                                )
                              ],
                            )
                          ),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                Text(
                                  "${snapshot.data.lat} ,",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                
                                Text(
                                  "${snapshot.data.long}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                          ),

                          Padding(padding: EdgeInsets.all(10)),

                          Container(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Feels Like:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          "${kelvinToCelcius(snapshot.data.feelsLike)}°C",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0,
                                            color: getColor(kelvinToCelcius(snapshot.data.feelsLike))
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Visibility:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data.visibility}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0,
                                            color: Colors.grey[700]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Pressure:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data.pressure} hPa",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.grey[700]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Humidity:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data.humidity}%",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.grey[700]
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(padding: EdgeInsets.all(5)),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Min Temp:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          "${kelvinToCelcius(snapshot.data.tempMin)}°C",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: getColor(kelvinToCelcius(snapshot.data.tempMin))
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "Max Temp:",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          "${kelvinToCelcius(snapshot.data.tempMax)}°C",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: getColor(kelvinToCelcius(snapshot.data.tempMax))
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical:10),
                            child: Text(
                              "Sunrise and Sunset:",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Container(
                                height: 150,
                                width: 150,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.only(left:10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: AssetImage("assets/images/sun.png"))
                                        ),
                                      ),
                                      Text(
                                        "${timestampToTime(snapshot.data.sunrise)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          wordSpacing: -1
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                height: 150,
                                width: 150,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.only(left:10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: AssetImage("assets/images/sea.png"))
                                        ),
                                      ),
                                      Text(
                                        "${timestampToTime(snapshot.data.sunset)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          wordSpacing: -1
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              );
            }
            else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),

                  RaisedButton(
                    child: Text(
                      "Cancel"
                    ),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        city = previousCity;
                      });
                    },
                  )
                ],
              );
            }
          },
        )
      ),
    );
  }

  Future<CityData> loadCityData(String city) async {
    final Response response = await get(Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}"));
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
    DateTime now = new DateTime.now();
    
    if(now.hour<18) {
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
    }
    else {
      switch(code) {
        case 01: asset = "assets/images/moon.png"; break;
        case 02: asset = "assets/images/few_cloud.png"; break;
        case 03: asset = "assets/images/scattered_dark.png"; break;
        case 04: asset = "assets/images/black_clouds_dark.png"; break;
        case 09: asset = "assets/images/shower.png"; break;
        case 10: asset = "assets/images/rain.png"; break;
        case 11: asset = "assets/images/thunder.png"; break;
        case 13: asset = "assets/images/snow.png"; break;
        case 50: asset = "assets/images/haze.png"; break;
      }
    }
    return DecorationImage(image: AssetImage(asset));
  }

  Color getColor(int temp) {
    if(temp<30) {
      return Colors.blue[700];
    }
    else if(temp<35) {
      return Colors.amber[700];
    } 
    else {
      return Colors.red[700];
    }
  }
}
