import 'package:flutter/material.dart';

class MyString {
  static const String ADRESS = "30.0.0.59";
  static const String FONTFAMILY = "Montserrat";
  // static const String BASE = 'http://30.0.0.59';
  static const String BASE = 'http://$ADRESS';
  static const String BASE_API = 'http://192.168.101.58:8097/';
  // static const String BASE_API = 'http://localhost:8097/';

  // static const CREATE_FEEDBACK_STATUS = '$BASE/create_feedback_status';
  // static String GET_DEVICE_API({String? deviceName, String? position}) {
  //   final url = '$BASE$deviceName?position=$position';
  //   // print(url);
  //   return url;
  // }

  static String GET_DEVICE_API2({int? index, double? position}) {
    final url = '$BASE/potentiometer?potIndex=$index&sliderValue=${position!*10}';
    // final url = 'http://127.0.0.1/potentiometer?potIndex=$index&sliderValue=$position';
    return url;
  }


  static String GET_LIST_VOLUME(endpoint) {
    return '$BASE_API$endpoint';
  }

  static String UPDATE_VOLUME_VALUE({endpoint, id}) {
    return '$BASE_API$endpoint/$id';
  }

  // ignore: non_constant_identifier_names
  static String UPDATE_PRESET_VOLUME_AS_CURRENT({endpoint, id}) {
    // debugPrint('url ${BASE_API$endpoint / $id}');
    debugPrint('$BASE_API$endpoint/$id');
    return '$BASE_API$endpoint/$id';
  }

  static String DELETE_PRESET_BY_ID({endpoint, id}) {
    return '$BASE_API$endpoint/$id';
  }

  static String GET_PRESET_LIST({endpoint}) {
    return '$BASE_API$endpoint';
  }

  static String CREATE_PRESET({endpoint}) {
    return '$BASE_API$endpoint';
  }
}
