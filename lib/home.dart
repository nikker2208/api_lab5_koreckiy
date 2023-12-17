import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const OpenWeather_API_Key = "c1ec93b3199602ab9d2f1ada6b80bf24";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  late DateTime nowTime;
  String city = "London";
  String zone = "Europe";
  Weather? _weather;
  final WeatherFactory _wf = WeatherFactory(OpenWeather_API_Key);
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getTime(city, zone));
    _wf.currentWeatherByCityName(city).then((w) =>
    {
      setState(() {
        _weather = w;
      }),
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: _buildUI(),
    );
  }
  Widget _buildUI(){
    if(_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          _locationHeader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.04,),
          _dateTimeInfo(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05,),
          _weatherIcon(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02,),
          _currTemp(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02,),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader(){
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget _dateTimeInfo(){
    return Column(
      children: [
        Text(
          DateFormat('kk:mm:ss').format(nowTime),
          style: const TextStyle(
            fontSize: 48,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd-MM-yyyy').format(nowTime),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_weather?.weatherDescription ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          ),
        ),
      ],
    );
  }
  Widget _currTemp(){
    return Text(
        "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: TextStyle(
        fontSize: 70,
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ));
    }
  Widget _extraInfo(){
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.15,
        width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20,),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),),
          Text(
            "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Скорость: ${_weather?.windSpeed?.toStringAsFixed(0)}м/с",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),),
              Text(
                "Влажность: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),),
            ],
          ),
        ],
      ),
      );
    }
  void getTime (String city, String zone) async {
    var url = "http://worldtimeapi.org/api/timezone/$zone/$city";
    final uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    Map data = jsonDecode(response.body);
    String datetime = data['datetime'];
    //print(datetime);
    DateTime now = DateTime.parse(datetime);
    setState(() {
      nowTime = now;
    });
  }
}


