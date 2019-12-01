import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clima/utilities/constants.dart';

const imgUrl = 'http://openweathermap.org/img/w/';

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temperature;
  String weatherIcon;
  String city;
  String message;
  String iconCode;
  String windSpeed;
  String pressure;
  String humidity;
  String description;
  String date;
  List list;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
    setDateString();
  }

  void setDateString() {
    date = DateFormat('EEEE, d MMM y').format(DateTime.now()).toUpperCase();
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        message = 'Unable to get data';
        city = '';
        return;
      }
      double temp = weatherData['list'][0]['main']['temp'];
      temperature = temp.toInt();
      int condition = weatherData['list'][0]['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      city = weatherData['city']['name'];
      message = weatherModel.getMessage(temperature);
      iconCode = weatherData['list'][0]['weather'][0]['icon'];
      windSpeed = weatherData['list'][0]['wind']['speed'].toString();
      description = weatherData['list'][0]['weather'][0]['description'];
      pressure = weatherData['list'][0]['main']['pressure'].toString();
      humidity = weatherData['list'][0]['main']['humidity'].toString();
      list = weatherData['list'];
    });
  }

  String getIcon(int index) {
    return list[index]['weather'][0]['icon'];
  }

  int getTemperature(int index) {
    return list[index]['main']['temp_max'].toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weatherModel.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 20.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typeName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));

                      if (typeName != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(typeName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.more_horiz,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      city.toUpperCase(),
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$temperature°',
                          style: TextStyle(fontSize: 110.0),
                        ),
                        Row(
                          children: <Widget>[
                            Image(
                              image: NetworkImage(imgUrl + '$iconCode.png'),
                            ),
                            Text(
                              '$description',
                              style:
                                  TextStyle(fontSize: 14.0, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 350.0,
                      color: Colors.white,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stats(
                          stat: '$windSpeed m/s',
                          statName: 'Wind',
                        ),
                        Stats(
                          stat: '$pressure hPa',
                          statName: 'Pressure',
                        ),
                        Stats(
                          stat: '$humidity%',
                          statName: 'Humidity',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DayTemperature(
                      day: 'Saturday',
                      icon: getIcon(0),
                      temperature: getTemperature(0),
                    ),
                    DayTemperature(
                      day: 'Sun',
                      icon: getIcon(1),
                      temperature: getTemperature(1),
                    ),
                    DayTemperature(
                      day: 'Mon',
                      icon: getIcon(2),
                      temperature: getTemperature(2),
                    ),
                    DayTemperature(
                      day: 'Tue',
                      icon: getIcon(3),
                      temperature: getTemperature(3),
                    ),
                    DayTemperature(
                      day: 'Wed',
                      icon: getIcon(4),
                      temperature: getTemperature(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayTemperature extends StatelessWidget {
  final String day;
  final String icon;
  final int temperature;

  DayTemperature(
      {@required this.day, @required this.icon, @required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            day.toUpperCase(),
            // style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image(
            image: NetworkImage(imgUrl + '$icon.png'),
          ),
          Text(
            '$temperature°',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class Stats extends StatelessWidget {
  final String statName;
  final String stat;

  Stats({this.statName, this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          Text(statName),
          Text(
            stat,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: 60.0,
            height: 2.0,
            // child: LinearProgressIndicator(
            //   value: 0.5,
            //   backgroundColor: Colors.white,
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            // ),
          ),
        ],
      ),
    );
  }
}
