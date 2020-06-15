class CityData {
  var lat;
  var long;
  WeatherList weatherList;
  var temp;
  var feelsLike;
  var tempMin;
  var tempMax;
  var pressure;
  var humidity;

  var visibility;
  var windSpeed;
  int sunrise;
  int sunset;

  String country;
  String cityName;


  CityData({this.lat,this.long,this.weatherList,this.temp,this.feelsLike,this.tempMin,this.tempMax,this.pressure,this.humidity
  ,this.visibility,this.windSpeed,this.sunrise,this.sunset,this.cityName,this.country});

  factory CityData.fromJson(Map<String,dynamic> json) {
    return CityData(
      lat: json['coord']['lat'],
      long: json['coord']['lon'],
      weatherList: WeatherList.fromJson(json['weather']),
      temp: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      visibility: json['visibility'],
      windSpeed: json['wind']['speed'],
      country: json['sys']['country'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      cityName: json['name']
    );
  }
}

class Weather {
  int id;
  String main;
  String description;
  String iconID;

  Weather({this.description,this.iconID,this.id,this.main});

  factory Weather.fromJson(Map<String,dynamic> json) {
    return Weather(
      id:json['id'],
      main: json['main'],
      description: json['description'],
      iconID: json['icon']
    );
  }
}

class WeatherList {
  final List<Weather> weathers;
  WeatherList({this.weathers});

  factory WeatherList.fromJson(List<dynamic> parsedJson) {
    List<Weather> weathers = List<Weather>();

    weathers = parsedJson.map((i) => Weather.fromJson(i)).toList();
    return WeatherList(weathers: weathers);
  }
}