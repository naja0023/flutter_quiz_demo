import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
GetIt getIt = GetIt.instance;

void setup(){
  getIt.registerLazySingleton(()=>NavigationService());
}
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}