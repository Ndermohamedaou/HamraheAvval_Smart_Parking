import 'dart:convert';
import 'package:xml2json/xml2json.dart';
import 'package:dio/dio.dart';

class WeatherForcaster {
  Dio dio = Dio();
  // For convert XML to JSON format
  Xml2Json xml2json = Xml2Json();
  // get Map from parsijo api
  Future<Map> getWeather() async {
    Response forcast = await dio
        .get("http://parsijoo.ir/api?serviceType=weather-API&q=pardis");
    xml2json.parse(forcast.data);
    var jx = xml2json.toGData();
    return json.decode(jx);
  }
}
