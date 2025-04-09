import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/getx/getx_controller_zonelist.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/page/floor.dart';
import 'package:volumn_control/page/preset.dart';
import 'package:volumn_control/page/widget/floorplan/floorplan_page.dart';
import 'package:volumn_control/page/zone.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/text_icon_item.dart';

class ControlPage extends StatefulWidget {
  final int indexPageView;
  const ControlPage({super.key, required this.indexPageView});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int _currentPageIndex = 0;
  late PageController _pageController;
  final controllerGetX = Get.put(MyGetXController());
  final ZoneListController controllerZoneList =
      Get.put(ZoneListController()); // Instantiate the controller

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.indexPageView;
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final double itemWidth =
        (width - (MyWidths.tab_padding(width / 25) * 2)) / 4 -
            PaddingD.padding16;
    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: PopScope(
          canPop: true,
          onPopInvokedWithResult:(didPop, result) => willPopCallback(),
          child: SafeArea(
              child: GetBuilder<MyGetXController>(
            builder: (controller) => Container(
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(MyAssets.bg), fit: BoxFit.cover)),
              width: width,
              height: height,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MyWidths.tab_padding(width / 25),
                      vertical: MyWidths.tab_padding(height / 50)),
                  child: customColumn(isTop: true, children: [
                    SizedBox(
                      height: MyWidths.tab_item_height(height),
                      child: customRow(children: [
                        text_icon_item(
                            smallAsset: true,
                            isActive: _currentPageIndex == 0 ? true : false,
                            smallBorder: true,
                            smallText: true,
                            hasWidth: true,
                            spacingHor: PaddingD.pading08,
                            paddingVer: PaddingD.pading08,
                            width: itemWidth,
                            onTap: () {
                              goToPageView(0);
                              controller.turnOffVisible();
                              controllerGetX.resetVolumeIndex();
                            },
                            pathAsset: MyAssets.floor,
                            text: "FLOOR\nPLAN"
                            // text: '${_currentPageIndex}'
                            ),
                        text_icon_item(
                            smallAsset: true,
                            smallBorder: true,
                            smallText: true,
                            hasWidth: true,
                            isActive: _currentPageIndex == 1 ? true : false,
                            spacingHor: PaddingD.pading08,
                            paddingVer: PaddingD.pading08,
                            width: itemWidth,
                            onTap: () {
                              goToPageView(1);
                              controllerZoneList.updateVolumeList();
                            },
                            pathAsset: MyAssets.zone,
                            text: "BY\nZONE"),
                        text_icon_item(
                            smallAsset: true,
                            smallBorder: true,
                            isActive: _currentPageIndex == 2 ? true : false,
                            smallText: true,
                            hasWidth: true,
                            spacingHor: PaddingD.pading08,
                            paddingVer: PaddingD.pading08,
                            width: itemWidth,
                            onTap: () {
                              goToPageView(2);
                            },
                            pathAsset: MyAssets.zone,
                            text: "BY\nFLOOR"),
                        text_icon_item(
                            smallAsset: true,
                            smallBorder: true,
                            smallText: true,
                            isActive: _currentPageIndex == 3 ? true : false,
                            hasWidth: true,
                            spacingHor: PaddingD.pading08,
                            paddingVer: PaddingD.pading08,
                            width: itemWidth,
                            onTap: () {
                              goToPageView(3);
                            },
                            pathAsset: MyAssets.preset,
                            text: "PRESET"),
                      ]),
                    ),
                    const SizedBox(
                      height: PaddingD.padding16,
                    ),
                    //body
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MyWidths.width_borderRadiusSmall),
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (index) {
                            debugPrint('current index: $index');
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          children: const [
                            FloorPlanPage(),
                            // FloorPlanPage(),
                            ZonePage(),
                            FloorPage(),
                            PresetPage(),
                          ],
                        ),
                      ),
                    )
                  ])),
            ),
          )),
        ));
  }

  void goToPageView(int targetPageIndex) {
    setState(() {
      _pageController.animateToPage(
        targetPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
