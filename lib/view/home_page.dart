import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pagination_demo_getx/controller/controller.dart';
import 'package:pagination_demo_getx/resource/app_colors.dart';

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
        body: Obx(() => value.dataModel.isNotEmpty
            ? LazyLoadScrollView(
                child: ListView.builder(
                  itemCount: value.dataModel.length,
                  itemBuilder: (context, index) {
                    if (value.dataModel[index] == value.dataModel.last) {
                      return Column(
                        children: [
                          ListTile(
                            leading: value.dataModel[index].thumbnailUrl != null
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        "${value.dataModel[index].thumbnailUrl}"),
                                  )
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
                                            color:AppColors.black,
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
                          Obx(() => value.newDataLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const SizedBox(height: 1))
                        ],
                      );
                    } else {
                      return ListTile(
                        leading: value.dataModel[index].thumbnailUrl != null
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    "${value.dataModel[index].thumbnailUrl}"),
                              )
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
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(value.dataModel[index].title!),
                            Obx(() => value.dataModel[index].isTrusted == true
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
                                        color:AppColors.black,
                                        size: 9,
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    width: 1,
                                  ))
                          ],
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
                    ? const CircularProgressIndicator()
                    :  Icon(
                        Icons.search,
                        color: AppColors.grey,
                        size: 200,
                      ),
              )));
  }
}
