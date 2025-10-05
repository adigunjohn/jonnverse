import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jonnverse/ui/screens/home_view.dart';

class NavigationService{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushNamed(String routeName){
    if(navigatorKey.currentState!=null){
      log('pushing to $routeName');
      return navigatorKey.currentState!.pushNamed(routeName);
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }
  Future<dynamic> replaceNamed(String routeName){
    if(navigatorKey.currentState!=null){
      log('pushing(replacing) to $routeName');
      return navigatorKey.currentState!.pushReplacementNamed(routeName);
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }
  Future<dynamic> pushToDashBoard(){
    if(navigatorKey.currentState!=null){
      log('pushing to HomeView');
      return navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> const HomeView()),(route)=>false);
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName) {
    if (navigatorKey.currentState != null) {
      log('pushing to $routeName and removing until predicate is met');
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName,(route) => false);
    } else {
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }

  Future<dynamic> push(Widget routeWidget){
    if(navigatorKey.currentState!=null){
      log('pushing to $routeWidget');
      return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => routeWidget));
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }

  void popUntil(String routeName){
    if(navigatorKey.currentState!=null){
      log('popping until $routeName');
      return navigatorKey.currentState!.popUntil((ModalRoute.withName(routeName)));
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }


  void pop(){
    if(navigatorKey.currentState!=null){
      log('popping');
      return navigatorKey.currentState!.pop();
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }
  }

  Future<dynamic> replace(Widget routeWidget){
    if(navigatorKey.currentState!=null){
      log('pushing(replacing) to $routeWidget');
      return navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (_) => routeWidget));
    }else{
      log('NavigationService navigatorKey is not attached to a Navigator.');
      throw StateError('NavigationService navigatorKey is not attached to a Navigator.');
    }

  }

}