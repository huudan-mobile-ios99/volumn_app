import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/model/preset_list_model.dart';
import 'package:volumn_control/model/volume.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/public/loader_dialog.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:dio/dio.dart';
import 'package:volumn_control/public/mywidths.dart';

class MyGetXController extends GetxController {
  RxBool visible = false.obs;
  RxBool isSwitch = false.obs;
  RxDouble valueSlider = 0.0.obs;
  RxList<VolumeModel> volumeList = <VolumeModel>[].obs;
  RxDouble dx = 0.0.obs;
  RxDouble dy = 0.0.obs;
  RxDouble zoomRatio = 1.0.obs;
  RxDouble valueSliderAll = 0.0.obs;
  RxBool hasChangeValueSlider = false.obs;
  RxBool isEditingPreset = false.obs;
  RxList<String> stringList = <String>[].obs;
  final serviceAPIs = MyAPIService();
  final dio = Dio();
  var volumes = <Volume>[].obs;
  Rx<Preset?> preset = Rx<Preset?>(null);
  Rx<Volume?> volume = Rx<Volume?>(null);
  RxInt volumeIndex = 0.obs;
  Rx<List<Volume>> listVolumes = Rx<List<Volume>>([]);

  RxList<Volume> volumesFloorPlan = <Volume>[].obs;
  @override
  void onInit() {
    super.onInit();
    listVolume();
    // fetchVolumesFloorPlan();
    saveVolumeMap(
        index: 0,
        newVolume: Volume(
            id: 'default',
            VolumeId: '0',
            name: 'default',
            deviceName: 'default',
            isSync: false,
            url: 'default',
            createdAt: DateTime.now(),
            minValue: 0,
            maxValue: MyWidths.SLIDER_MAX_VALUE,
            currentValue: 0,
            presetId: 'default',
            v: 0,
            type: 0,
            dx: 0,
            dy: 0));
  }

  Future<void> fetchVolumesFloorPlan() async {
    try {
      final VolumeListModel result = await serviceAPIs.listVolme();
      volumesFloorPlan.value = result.data;
      debugPrint('fetchVolumesFloorPlan, total result: ${result.data.length}');
    } catch (e) {
      debugPrint('Error fetching floorplan volumes: $e');
    }
  }

  Future<void> updateVolumePositionFloorPlan(
      String _id, double newCurrentValue) async {
    // Find the volume with the given _id
    final volumeIndex =
        volumesFloorPlan.indexWhere((volume) => volume.id == _id);
    if (volumeIndex != -1) {
      // Volume found, update its currentValue
      final updatedVolume =
          volumesFloorPlan[volumeIndex].copyWith(currentValue: newCurrentValue);
      volumesFloorPlan[volumeIndex] = updatedVolume;
      debugPrint('Updated currentValue for volume with id $_id');
    } else {
      debugPrint('Volume with id $_id not found.');
    }
  }

  @override
  void onClose() {
    volumesFloorPlan = <Volume>[].obs;
    super.onClose();
  }

  void updateVolumeListFloorPlan() async {
    await fetchVolumesFloorPlan();
  }

  // Method to save a VolumeModel
  void saveVolume(VolumeModel volume) {
    bool itemExists = volumeList
        .any((item) => item.id == volume.id && item.name == volume.name);
    if (itemExists) {
      int index = volumeList.indexWhere(
          (item) => item.id == volume.id && item.name == volume.name);
      volumeList[index].currentValue = volume.currentValue;
    } else {
      volumeList.add(volume);
    }
    debugPrint('All items in volumeList:');
    for (var item in volumeList) {
      debugPrint(
          '${item.name} / ${item.id} / ${item.currentValue} / ${item.urlName} / ${item.isShow}');
    }
  }

//show slider volumn model
  VolumeModel? showVolume() {
    var showItem = volumeList.firstWhere(
      (item) => item.isShow,
    );
    if (showItem == null && volumeList.isNotEmpty) {
      showItem = volumeList.first;
    }
    debugPrint(
        '${showItem.name} / ${showItem.id} / ${showItem.currentValue} / ${showItem.urlName} / ${showItem.isShow}');
    return showItem;
  }

  void toggleVisible() {
    visible.toggle();
    resetVolumeIndex();
  }

  void toggleSwitch() {
    isSwitch.toggle();
  }

  void toggleEditingPreset() {
    isEditingPreset.toggle();
  }

  void turnOffEditingPreset() {
    isEditingPreset.value = false;
  }

  void toggleHasChangeValueSlider() {
    hasChangeValueSlider.toggle();
  }

  void turnOnVisible() {
    visible.value = true;
  }

  void turnOffVisible() {
    visible.value = false;
  }

  void saveZoomRatio(double value) {
    zoomRatio.value = value;
  }

  void saveDxDy({double? dxValue, double? dyValue}) {
    dx.value = dxValue!;
    dy.value = dyValue!;
  }

  //save value slider
  void saveValueSlider(double value) {
    valueSlider.value = value;
    update();
  }

  void saveValueSliderOnly(double value) {
    valueSliderAll.value = value;
    // update();
  }

  //save value slider
  void saveValueSliderAll({required double value, required context}) async {
    valueSliderAll.value = value;
    serviceAPIs.listVolme().then((value) async {
      showLoaderDialog(context);
      for (int i = 0; i < value.data.length; i++) {
        // debugPrint('volume item: ${value.data[i].currentValue}');
        // debugPrint('value slider current: ${valueSliderAll.value}');
       await serviceAPIs.runDeviceFullURL(
            url: MyString.GET_DEVICE_API2(
                index: int.parse(value.data[i].VolumeId),
                position: valueSliderAll.value));
        updateVolumesCurrentValue(value.data, valueSliderAll.value);
        serviceAPIs.updateVolumeValue( value: valueSliderAll.value, id: value.data[i].id);
        
      }
    }).whenComplete(() {
      debugPrint('complete list volume zone sync');
      Navigator.of(context, rootNavigator: false).pop();
    });
    // .timeout(Durations.medium4,onTimeout: () {
    //   debugPrint('timeout reached');
    // },);
  }

  void updateValueSliderAll(
    double value,
  ) {
    serviceAPIs.listVolme().then((value) async {
      for (int i = 0; i < value.data.length; i++) {
        serviceAPIs.runDeviceFullURL(
            url: MyString.GET_DEVICE_API2(
                index: int.parse(value.data[i].VolumeId),
                position: valueSliderAll.value));
      }
    });
  }

  //save all id to a list<String>
  void saveStringToList(Rx<String> stringRx) {
    // Listen to changes in the stringRx
    ever(stringRx, (_) {
      // Update the stringList with the new value from stringRx
      stringList.assignAll([stringRx.value]);
    });
    stringList.assignAll([stringRx.value]);
  }

  List<String> getListStringId() {
    return stringList.toList();
  }

  //save list volumne
  Future<VolumeListModel> listVolume() async {
    try {
      var response = await dio.get(
        MyString.GET_LIST_VOLUME('list_volume'),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ),
      );
      var volumeListModel = VolumeListModel.fromJson(response.data);
      volumes.assignAll(volumeListModel.data);
      update();
      return volumeListModel;
    } finally {}
  }

  //retrieve list volume
  List<Volume> getListVolume() {
    // ignore: invalid_use_of_protected_member
    for (var element in volumes) {
      debugPrint('${element.currentValue}');
    }
    return volumes.value;
  }

  Future updateVolumes(List<Volume> newVolumes) async {
    try {
      return volumes.assignAll(newVolumes);
    } catch (e) {
      debugPrint('Error updating volumes: $e');
      rethrow;
    }
  }

  Future<void> updateVolumesCurrentValue(
      List<Volume> newVolumes, double newCurrentValue) async {
    try {
      // Create a new list with updated currentValue
      List<Volume> updatedVolumes = newVolumes
          .map((volume) => Volume(
              id: volume.id,
              VolumeId: volume.VolumeId,
              name: volume.name,
              deviceName: volume.deviceName,
              isSync: volume.isSync,
              url: volume.url,
              createdAt: volume.createdAt,
              minValue: volume.minValue,
              maxValue: volume.maxValue,
              currentValue: newCurrentValue, // Update currentValue here
              presetId: volume.presetId,
              v: volume.v,
              type: 1,
              dx: 0.0,
              dy: 0.0))
          .toList();
      // Update the volumes list with the new list
      volumes.assignAll(updatedVolumes);
      update();
    } catch (e) {
      debugPrint('Error updating volumes: $e');
      rethrow;
    }
  }

  void savePreset(Preset newPreset) {
    deletePreset();
    preset.value = newPreset;
  }

  void deletePreset() {
    preset.value = null;
  }

  void saveVolumeMap({required Volume newVolume, required int index}) {
    deleteVolumeMap();
    volume.value = Volume(
      id: newVolume.id,
      VolumeId: newVolume.VolumeId, // Assign the new VolumeId here
      name: newVolume.name,
      deviceName: newVolume.deviceName,
      isSync: newVolume.isSync,
      url: newVolume.url,
      createdAt: newVolume.createdAt,
      minValue: newVolume.minValue,
      maxValue: newVolume.maxValue,
      currentValue: newVolume.currentValue,
      presetId: newVolume.presetId,
      v: newVolume.v,
      type: newVolume.type,
      dx: newVolume.dx,
      dy: newVolume.dy,
    );
    // debugPrint('volume id: ${volume.value?.VolumeId}');
    // return volume;
    volumeIndex.value = index;
  }

  void saveVolumeMapIndex(int index) {
    volumeIndex.value = index;
  }

  void resetVolumeIndex() {
    volumeIndex.value = 0;
    update();
  }

  void deleteVolumeMap() {
    volume.value = null;
  }

  // Method to update the currentValue of a Volume in the current preset by its ID
  void updatePresetVolumeCurrentValue(
      {required String volumeId, required double newValue}) {
    preset.value;
    if (preset.value != null) {
      int index = preset.value!.volumes
          .indexWhere((volume) => volume.VolumeId == volumeId);
      if (index != -1) {
        Volume volumeToUpdate = preset.value!.volumes[index];
        Volume updatedVolume = Volume(
          id: volumeToUpdate.id,
          VolumeId: volumeToUpdate.VolumeId,
          name: volumeToUpdate.name,
          deviceName: volumeToUpdate.deviceName,
          isSync: volumeToUpdate.isSync,
          url: volumeToUpdate.url,
          createdAt: volumeToUpdate.createdAt,
          minValue: volumeToUpdate.minValue,
          maxValue: volumeToUpdate.maxValue,
          currentValue: newValue, // Update the currentValue
          presetId: volumeToUpdate.presetId,
          v: volumeToUpdate.v,
          type: volumeToUpdate.type,
          dx: volumeToUpdate.dx,
          dy: volumeToUpdate.dy,
        );
        preset.value!.volumes[index] = updatedVolume;

        debugPrint(
            'preset value has been saved : ${updatedVolume.currentValue}');
        // update();
        preset.refresh(); // Refresh the UI to reflect the changes
      }
    }
  }

  void saveVolumes(List<Volume> volumes) {
    deleteListVolume();
    listVolumes.value = volumes;
    for (var element in volumes) {
      debugPrint('saveVolumes ${element.currentValue}');
    }
  }

  void deleteListVolume() {
    listVolumes.value = [];
  }
}
