import 'package:flutter/material.dart';

///
/// Create by Hugo.Guo
/// Date: 2019-08-09
///
class RouteNameUtil {
  /// name+id
  static String getRouteNameWithId(BuildContext context) {
    if (context == null) {
      return null;
    }
    String name = context.widget?.toString();
    if (name == null) {
      return null;
    }
    String contextString = context.toString();
    if (contextString == null) {
      return name;
    }
    String id;
    try {
      id = contextString.substring(
          contextString.indexOf("#"), contextString.indexOf("(lifecycle"));
    } catch (e) {
      id = null;
    }
    if (id == null) {
      return name;
    }
    return name + id;
  }

  /// name
  static String getRouteName(BuildContext context) {
    if (context == null) {
      return null;
    }
    String name = context.widget?.toString();
    if (name == null) {
      return null;
    }
    return name;
  }
}
