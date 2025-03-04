import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/core/services/services.dart';

class Middleware extends GetMiddleware{
  int? get priority =>  1;
  MyServices myServices = Get.find();
  @override
  RouteSettings? redirect (String? route ){
    if(myServices.sharedPreferences.getString("onboarding")=="1"){
     // return RouteSettings(name:AppRoute.login);
    }


  }


}