import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/model/preset_list_model.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/public/myAPIstring.dart';

class MyAPIService {
  Dio dio = Dio();
  final myDio = Dio();

  Future runDevice({index, position}) async {
    final myString = MyString.GET_DEVICE_API2(index: index, position: position);
    debugPrint('runDevice string $myString');
    debugPrint(myString);
    final response = await dio.get(
      myString,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    print('runDevice ${response.data}');
    return response.data;
  }

  Future runDevice2({index, position}) async {
    final myString = MyString.GET_DEVICE_API2(index: index, position: position);
    // debugPrint('runDevice string $myString');
    debugPrint(myString);
    final response = await dio.get(
      myString,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('runDevice2 ${response.data}');
    return response.data;
  }

  // USER THIS TO RUN DEVICE
  Future<dynamic> runDeviceFullURL({required url}) async {
    debugPrint('runDeviceFullURL URL: ${url}');
    final response = await dio.get(
      url,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint('runDeviceFullURL RES:  ${response.data}');
    return response.data;
  }


// Future runDeviceFullURL({required String url}) async {
//   debugPrint('runDeviceFullURL APIs');
//   debugPrint('runDeviceFullURL url1 ${MyString.GET_DEVICE_API_FULLURL(url)}');
  
//   final response = await http.get(
//     Uri.parse(MyString.GET_DEVICE_API_FULLURL(url)),
//     headers: {
//       'Content-type': 'application/json; charset=UTF-8',
//     },
//   );
//   if (response.statusCode == 200) {
//     print('runDeviceFullURL response data:  ${response.body}');
//     return jsonDecode(response.body);
//   } else {
//     print('Failed to load data from server: ${response.statusCode}');
//     throw Exception('Failed to load data from server: ${response.statusCode}');
//   }
// }


  // Future runDeviceFullURL2({required url}) async {
  //   final myString = MyString.GET_DEVICE_API_FULLURL(url);
  //   debugPrint('url full 2:${MyString.GET_DEVICE_API_FULLURL(url)}');
  //   debugPrint('runDeviceFullURL $myString');
  //   final response = await dio.get(
  //     // MyString.GET_DEVICE_API_FULLURL(url),
  //     myString,
  //     // options: Options(
  //     //   contentType: Headers.jsonContentType,
  //     //   headers: {
  //     //     'Content-type': 'application/json; charset=UTF-8',
  //     //   },
  //     // ),
  //   );
  //   debugPrint('runDeviceFullURL2 ${response.data}');
  //   return response.data;
  // }
  Future<VolumeListModel> listVolme() async {
    try {
      final response = await dio.get(
        MyString.GET_LIST_VOLUME('list_volume'),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      return VolumeListModel.fromJson(response.data);
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }
  

  //USING HTTP 
  //  Future<VolumeListModel> listVolme() async {
  //   try {
  //     final url = MyString.GET_LIST_VOLUME('list_volume');
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-type': 'application/json; charset=UTF-8',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return VolumeListModel.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     throw e;
  //   }
  // }

  Future<dynamic> updateVolumeValue({value, id}) async {
    final Map<String, dynamic> body = {
      "currentValue": value,
    };
    final response = await dio.post(
      MyString.UPDATE_VOLUME_VALUE(endpoint: 'update_volume_value', id: id),
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint( 'updateVolumeValue: ${response.data['data']['currentValue']} ${response.data['data']['_id']}');
    return (response.data);
  }

  //update preset'volume data as current
  Future updatePresetVolumeAsCurrent({required String presetID}) async {
    debugPrint('updatePresetVolumeAsCurrent');
    final response = await dio.get(
      MyString.UPDATE_PRESET_VOLUME_AS_CURRENT(
          endpoint: 'preset_update_volume_value', id: presetID),
      options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: const Duration(seconds: 10)),
    );
    debugPrint('updatePresetVolumeAsCurrent: ${response.data}');
    return response.data;
  }

  //update with getX
  Future<dynamic> updateVolumeValueGetX(
      {value, id, required MyGetXController controllerGetX}) async {
    final Map<String, dynamic> body = {
      "currentValue": value,
    };
    final response = await dio.post(
      MyString.UPDATE_VOLUME_VALUE(endpoint: 'update_volume_value', id: id),
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    debugPrint(
        'update current value volume: ${response.data['data']['currentValue']} ${response.data['data']['_id']}');
    controllerGetX.updatePresetVolumeCurrentValue(
        volumeId: response.data['data']['_id'],
        newValue: response.data['data']['currentValue']);
    return (response.data);
  }

  Future<PresetListModel> listPreset({value, id}) async {
    final Map<String, dynamic> body = {
      "currentValue": value,
    };
    final response = await dio.get(
      MyString.GET_PRESET_LIST(endpoint: 'list_preset'),
      data: body,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    return PresetListModel.fromJson(response.data);
  }

  //CREATE PRESET
  Future createPreset({
    required String presetID,
    required String presetName,
    required List<Volume> volumes,
  }) async {
    // Convert volumes to JSON
    List<Map<String, dynamic>> volumesJson =
        volumes.map((volume) => volume.toJson()).toList();
    try {
      Map<String, dynamic> body = {
        "presetId": presetID,
        "presetName": presetName,
        "volumes": volumesJson,
      };
      // Convert volumes to JSON
      final response = await dio.post(
        MyString.CREATE_PRESET(endpoint: 'create_preset'),
        data: body,
        options: Options(
            contentType: Headers.jsonContentType,
            sendTimeout: const Duration(seconds: 10)),
      );
      // debugPrint(response.data);
      return response.data;
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  //CREATE PRESET
  Future createPresetFix({
    required String presetID,
    required String presetName,
  }) async {
    try {
      Map<String, dynamic> body = {
        "presetId": presetID,
        "presetName": presetName,
      };
      // Convert volumes to JSON
      final response = await dio.post(
        MyString.CREATE_PRESET(endpoint: 'create_preset_fix'),
        data: body,
        options: Options(
            contentType: Headers.jsonContentType,
            sendTimeout: const Duration(seconds: 10)),
      );
      // debugPrint('${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<dynamic> deletePresetById({id}) async {
    final response = await dio.delete(
      MyString.DELETE_PRESET_BY_ID(endpoint: 'delete_preset', id: id),
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      ),
    );
    // debugPrint(response.data);
    return (response.data);
  }
}
