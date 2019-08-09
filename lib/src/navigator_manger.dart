import 'package:flutter/material.dart';

/// 管理生命周期
class NavigatorManger {
  List<String> _activityStack = new List<String>();

  NavigatorManger._internal();

  static NavigatorManger _singleton = new NavigatorManger._internal();

  //工厂模式
  factory NavigatorManger() => _singleton;

  void addWidget(String className) {
    _activityStack.add(className);
  }

  void removeWidget(String className) {
    _activityStack.remove(className);
  }

  bool isTopPage(String className) {
    if (_activityStack == null) {
      return false;
    }
    try {
      return className == _activityStack[_activityStack.length - 1];
    } catch (exception) {
      return false;
    }
  }

  bool isSecondTop(String className) {
    if (_activityStack == null) {
      return false;
    }
    try {
      return className == _activityStack[_activityStack.length - 2];
    } catch (exception) {
      return false;
    }
  }
}
