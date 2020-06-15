class CityData {
  double lat;
  double long;
  WeatherList weatherList;
  double temp;
  double feelsLike;
  double temp_min;
  double temp_max;
  double pressure;
  double humidity;

  double visibility;
  double windSpeed;
  int sunrise;
  int sunset;

  String country;
  String cityName;

  CityData({this.lat,this.long,this.weatherList,this.temp,this.feelsLike,this.temp_min,this.temp_max,this.pressure,this.humidity
  ,this.visibility,this.windSpeed,this.sunrise,this.sunset,this.cityName,this.country});

  factory CityData.fromJson(Map<String,dynamic> json) {
    return CityData(
      lat: json['coord']['lat'],
      long: json['coord']['lon'],
      weatherList: WeatherList.fromJson(json['weather']),
      temp: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      temp_min: json['main']['temp_min'],
      temp_max: json['main']['temp_max'],
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