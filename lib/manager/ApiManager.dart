import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

export 'package:dio/dio.dart';

enum ApiMethod {
  GET, POST, DELETE
}

class ApiParameters {
  static const Map<String, dynamic> getData = {"naming": "EID"};

  static const Map<String, dynamic> saveData = {
    "mobile": true,
    "v2" : "",
    "api" : true,
    "fr" : true,
  };

  static const Map<String, dynamic> uploadFile = {
    "mobile": true,
    "v2" : "",
    "api" : true,
    "fr" : true,
    "doFormula" : true,
    "upload" : true,
  };
}

class ApiManager {
  final ApiMethod apiMethod;
  final String url;
  final Map<String, dynamic>? parameters;
  final dynamic postData;

  ApiManager({
    required this.apiMethod,
    required this.url,
    this.parameters,
    this.postData,
  });

  Future<Response> call() async {
    Dio dio = Dio();
    dio.options.baseUrl = url;
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.options.headers['Authorization'] = "Basic " + "eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA==";
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    switch(apiMethod) {
      case ApiMethod.GET:
        return await dio.get("?api", queryParameters: parameters, data: postData);
      case ApiMethod.POST:
        return await dio.post("?api", queryParameters: parameters, data: postData);
      case ApiMethod.DELETE:
        return await dio.delete("?api", queryParameters: parameters, data: postData);
    }
  }
}