import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:pagination_demo_getx/controller/controller.dart';
import 'package:pagination_demo_getx/resource/app_colors.dart';
import 'package:pagination_demo_getx/resource/string_resource.dart';
import 'package:pagination_demo_getx/view/show_data_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetDataController value = Get.put(GetDataController());
    Timer? debounce;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: TextField(
            controller: value.searchController,
            decoration: const InputDecoration(hintText: "search"),
            onChanged: (v) {
              if (debounce?.isActive ?? false) debounce?.cancel();
              debounce = Timer(const Duration(milliseconds: 500), () {
                if (v.isNotEmpty) {
                  value.searchData(v, 0);
                } else {
                  value.clearAllData();
                  value.isDataLoading(false);
                }
              });
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            value.scrollUp();
          },
          child: Icon(Icons.arrow_upward_rounded),
        ),
        body: GetBuilder<GetDataController>(
          init: GetDataController(),
          builder: (controller) => Obx(() => value.dataModel.isNotEmpty
              ? LazyLoadScrollView(
                  child: ListView.builder(
                    controller: value.scrollController,
                    itemCount: value.dataModel.length,
                    itemBuilder: (context, index) {
                      if (value.dataModel[index] == value.dataModel.last) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => ShowDataPage(),
                                        arguments: value.dataModel[index])!
                                    .then((v) => value.refresh());
                              },
                              child: ListTile(
                                leading: Obx(
                                  () => value.dataModel[index].thumbnailUrl !=
                                          null
                                      ? Obx(() => value
                                              .dataModel[index].thumbnailUrl!
                                              .contains("https")
                                          ? Obx(() => CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: NetworkImage(
                                                    "${value.dataModel[index].thumbnailUrl}"),
                                              ))
                                          : Obx(() => CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: FileImage(File(
                                                    "${value.dataModel[index].thumbnailUrl}")),
                                              )))
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: AppColors.liteGrey,
                                              shape: BoxShape.circle),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "#",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                ),
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(value.dataModel[index].title!),
                                    Obx(() => value
                                                .dataModel[index].isTrusted ==
                                            true
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Container(
                                              height: 12,
                                              width: 12,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.green),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.check,
                                                color: AppColors.black,
                                                size: 9,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 1,
                                          ))
                                  ],
                                ),
                              ),
                            ),
                            Obx(() => value.newDataLoading.value
                                ? Center(

                                    child: Lottie.asset(
                                        StringResource.loadingAnimation,
                                        width: 100),
                                  )
                                : const SizedBox(height: 1))
                          ],
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Get.to(() => ShowDataPage(),
                                arguments: value.dataModel[index]);
                          },
                          child: ListTile(
                            leading: Obx(() => value
                                        .dataModel[index].thumbnailUrl !=
                                    null
                                ? Obx(() => value.dataModel[index].thumbnailUrl!
                                        .contains("https")
                                    ? Obx(() => CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              "${value.dataModel[index].thumbnailUrl}"),
                                        ))
                                    : Obx(() => CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: FileImage(File(
                                              "${value.dataModel[index].thumbnailUrl}")),
                                        )))
                                : Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: AppColors.liteGrey,
                                        shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "#",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(value.dataModel[index].title!),
                                Obx(() => value.dataModel[index].isTrusted ==
                                        true
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                          height: 12,
                                          width: 12,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.green),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.check,
                                            color: AppColors.black,
                                            size: 9,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 1,
                                      ))
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  onEndOfPage: () {
                    value.loadMoreData(value.searchController.text);
                  })
              : Center(
                  child: value.isDataLoading.value
                      ? Lottie.asset(StringResource.searchAnimation,
                          height: 200, width: 200, fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "NO DATA!!",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Please search..",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                )),
        ));
  }
}
