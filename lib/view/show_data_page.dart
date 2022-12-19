import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagination_demo_getx/controller/controller.dart';
import 'package:pagination_demo_getx/controller/image_controller.dart';
import 'package:pagination_demo_getx/model/model.dart';
import 'package:pagination_demo_getx/resource/app_colors.dart';

class ShowDataPage extends StatelessWidget {
  const ShowDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageController value = Get.put(ImageController());
    GetDataController homeController = Get.find();

    DataModel data = Get.arguments;
    print(data.title);
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           GetBuilder<ImageController>(
             init: ImageController(),
             builder: (controller) {
               print( value.imagePath.isEmpty);

             return   Obx(() =>  data.thumbnailUrl != null && value.imagePath.isEmpty
                 ? Padding(
               padding: const EdgeInsets.only(top: 30),
               child: Container(
                 height: 200,
                 width: 200,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         fit: BoxFit.cover,
                         image: data.thumbnailUrl!.contains("https") ?  NetworkImage("${data.thumbnailUrl}"): FileImage(File("${data.thumbnailUrl}")) as ImageProvider ),
                     shape: BoxShape.circle,
                     color: AppColors.transparent),
               ),
             )
                 : value.imagePath.isNotEmpty ? Padding(
               padding: const EdgeInsets.only(top: 30),
               child: Container(
                 height: 200,
                 width: 200,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         fit: BoxFit.cover,
                         image: FileImage(File(value.imagePath.value))),
                     shape: BoxShape.circle,
                     color: AppColors.transparent),
               ),
             ):Padding(
                 padding: const EdgeInsets.only(top: 30),
                 child: Stack(
                   alignment: Alignment.bottomRight,
                   children: [
                     Container(
                       height: 200,
                       width: 200,
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: AppColors.liteGrey),
                       alignment: Alignment.center,
                       child: Text(
                         "#",
                         style: TextStyle(
                             fontSize: 100,
                             color: Colors.grey,
                             fontWeight: FontWeight.bold
                         ),
                       ),
                     ),
                     InkWell(
                       onTap: (){
                         Get.defaultDialog(
                             title: "Choose Image from",
                             actions: [
                               Column(children: [
                                 TextButton(onPressed: () {
                                   value.getCameraImage().then((v) {
                                     data.thumbnailUrl = value.imagePath.value;
                                     homeController.update();
                                     Get.back();
                                   });



                                 }, child: Text("CAMERA")),TextButton(onPressed: () {
                                   value.getGalleryImage().then((v) {
                                     data.thumbnailUrl = value.imagePath.value;
                                     homeController.update();
                                     Get.back();
                                   });
                                 }, child: Text("GALLERY")),
                               ],)
                             ]
                         );
                       },
                       child: Container(
                         height: 50,
                         width: 50,
                         decoration: BoxDecoration(
                             color: Colors.blue, shape: BoxShape.circle),
                         alignment: Alignment.center,
                         child: Icon(
                           Icons.camera_alt,
                           color: Colors.white,
                         ),
                       ),
                     )
                   ],
                 )),);
           },),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Text(
                    "${data.title}",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
