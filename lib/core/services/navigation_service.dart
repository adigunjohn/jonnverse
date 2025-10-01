import 'package:flutter/material.dart';
import 'package:jonnverse/ui/screens/home_view.dart';

class NavigationService{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(String routeName){
    if(navigatorKey.currentState!=null){
      return navigatorKey.currentState!.pushNamed(routeName);
    }else{
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }

  }
  Future<dynamic> pushToDashBoard(){
    if(navigatorKey.currentState!=null){
      return navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> const HomeView()),(route)=>false);
    }else{
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }

  }

  Future<dynamic> push(Widget routeWidget){
    if(navigatorKey.currentState!=null){
      return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => routeWidget));
    }else{
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }
  void pop(){
    if(navigatorKey.currentState!=null){
      return navigatorKey.currentState!.pop();
    }else{
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }

  Future<dynamic> replace(Widget routeWidget){
    if(navigatorKey.currentState!=null){
      return navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (_) => routeWidget));
    }else{
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }

  }

}