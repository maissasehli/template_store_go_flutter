import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:store_go/core/constants/routes_constants.dart';
import 'package:store_go/core/services/services.dart';

class Middleware extends GetMiddleware{
  @override
  int? get priority =>  1;
  MyServices myServices = Get.find();
  @override
  RouteSettings? redirect (String? route ){
    if(myServices.sharedPreferences.getString("onboarding")=="1"){
      return const RouteSettings(name:AppRoute.login);
    }
    return null;
  }
}