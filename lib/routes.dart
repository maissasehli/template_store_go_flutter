import 'package:get/get.dart';
import 'package:store_go/bindings/auth_binding.dart';
import 'package:store_go/core/constants/routes.dart';
import 'package:store_go/view/screens/auth/login.dart';
import 'package:store_go/view/screens/language/language.dart';
import 'package:store_go/view/screens/onboarding/onbordingScreen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => const Language(), middlewares: []),
  
  // OnBoarding
  GetPage(name: AppRoute.onBoarding, page: () => Onboarding()),
  
  // Auth
  GetPage(
    name: AppRoute.login, 
    page: () => const Login(),
    binding: AuthBinding(), // Utilisez le nouveau binding ici
  ),
];