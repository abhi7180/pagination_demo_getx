import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_demo_getx/model/model.dart';
import 'package:pagination_demo_getx/repositories/repositories.dart';

class GetDataController extends GetxController {
  RxList<DataModel> dataModel = <DataModel>[].obs;
  RxBool isDataLoading = false.obs;
  var searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxInt pageIndex = 0.obs;
  RxBool newDataLoading = false.obs;
  RxBool isSearch = false.obs;

  Future<void> searchData(String searchText, pageIndex) async {
    clearAllData();

    try {
      isDataLoading(true);

      Repository().getApiData(pageIndex, searchText).then((v) {
        var data = jsonDecode(v);
        for (var i in data['items']) {
          dataModel.add(DataModel.fromJson(i));
        }
        isDataLoading(false);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void scrollUp() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  loadMoreData(String searchText) {
    try {
      newDataLoading(true);

      pageIndex++;

      Repository().getApiData(pageIndex.value, searchText).then((v) {
        var data = jsonDecode(v);
        for (var i in data['items']) {
          dataModel.add(DataModel.fromJson(i));
        }
        newDataLoading(false);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void clearAllData() {
    dataModel.clear();
    update();
  }
}
