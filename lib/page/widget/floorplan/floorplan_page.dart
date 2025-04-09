import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/page/widget/floorplan/floorplan_list.dart';
import 'package:volumn_control/page/widget/floorplan/floorplan_list_getx.dart';
import 'package:volumn_control/public/deboucer.dart';
import 'package:volumn_control/public/loader_dialog.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_text.dart';

class FloorPlanPage extends StatefulWidget {
  // final Callback onPressUpdateWidget;
  const FloorPlanPage({
    super.key,
  });

  @override
  State<FloorPlanPage> createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends State<FloorPlanPage> {
  final MyGetXController controllerGetX = Get.put(MyGetXController());
  final serviceAPIs = MyAPIService();
  final debouncer = Debouncer(milliseconds: 500, delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    debugPrint('INIT FLOORPLAN_PAGE');
    controllerGetX.updateVolumeListFloorPlan();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(children: [
      PhotoView(
        loadingBuilder: (context, event) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              value: event == null
                  ? null
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          );
        },
        imageProvider: const AssetImage( MyAssets.map), // Replace 'assets/image.jpg' with your image path
        backgroundDecoration:  BoxDecoration(
          color: MyColor.seashell,
        ),
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.contained * 1,
      ),

      FloorPlanListGetX(),
      // const FloorPlanList(),
      
      Positioned(
          top: MyWidths.height_center_point(height),
          child: Container(height: 1, width: width, color: MyColor.grey_tab)),
      Positioned(
          left: MyWidths.width_center_point(width),
          child: RotatedBox(
              quarterTurns: 3,
              child: Container(height: 1, width: width, color: MyColor.grey_tab))),
      
      GetBuilder<MyGetXController>(builder: (controller)=>
      Positioned(
          left:  controllerGetX.volume.value!.type == 2 ? 0 : null ,
          right: controllerGetX.volume.value!.type == 0 ? 0 : null,
         
          child: controllerGetX.visible.value == true
              ? Container(
                  width: width / 5,
                  height: height,
                  alignment: Alignment.center,
                  decoration:  BoxDecoration(
                    color: MyColor.bedgeLight,
                    border: Border(
                      left:controllerGetX.volume.value!.type == 0? const BorderSide(color: MyColor.yellow_accent, width: 2)  : BorderSide.none,
                      right:controllerGetX.volume.value!.type == 2? const BorderSide(color: MyColor.yellow_accent, width: 2)  : BorderSide.none,
                    ),
                  ),
                  child: controllerGetX.volume.value != null
                      ? customSlider(
                          text: controllerGetX.volume.value!.name,
                          width: MyWidths.slider_item_width,
                          height: height * .5,
                          onClose: () {
                            controllerGetX.turnOffVisible();
                            controllerGetX.resetVolumeIndex();
                            // controllerGetX.updateVolumeListFloorPlan();
                          },
                          onChange: (double value) {
                            // debugPrint('onChange floorplan page: $value');
                            //SHOW LOADER 
                            controllerGetX.saveValueSlider(value);
                            debouncer.run(() async {
                              showLoaderDialog(context);
                              // debugPrint('value floorplan page slider: ${controllerGetX.valueSlider.value}');
                              serviceAPIs.updateVolumeValue(
                                  id: controllerGetX.volume.value!.id,
                                  value: controllerGetX.valueSlider.value).then((value){
                                    if(value['status']==true){
                                      print(value);
                                      controllerGetX.updateVolumePositionFloorPlan(controllerGetX.volume.value!.id,controllerGetX.valueSlider.value);
                                    }
                                  });
                             await serviceAPIs.runDeviceFullURL(
                                      url: MyString.GET_DEVICE_API2(
                                          index: int.parse(controllerGetX.volume.value!.VolumeId),
                                          position:controllerGetX.valueSlider.value,
                                          // position: '1000'
                                          ))
                                  .then((value) {})
                                  .whenComplete(() => Navigator.of(context).pop());
                            });
                            //update all map
                            // debugPrint('update all map here');
                          })
                      : text_custom_center(text: "no volume saved"),
                )
              : Container(),
        ),)
    ]);
  }
}
