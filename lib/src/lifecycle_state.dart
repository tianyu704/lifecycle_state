import 'package:flutter/material.dart';

import 'route_name_util.dart';
import 'navigator_manger.dart';

///
/// Create by Hugo.Guo
/// Date: 2019-08-08
///
abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  bool _onResumed = false; //页面展示标记
  bool _onPause = false; //页面暂停标记
  String _className;

  get className => _className;

  @override
  void initState() {
    // TODO: implement initState
    _className = RouteNameUtil.getRouteNameWithId(context);
    NavigatorManger().addWidget(_className);
    WidgetsBinding.instance.addObserver(this);
    onCreate();
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    //说明是被覆盖了
    if (NavigatorManger().isSecondTop(_className)) {
      if (!_onPause) {
        onPause();
        _onPause = true;
      } else {
        onResume();
        _onPause = false;
      }
    } else if (NavigatorManger().isTopPage(_className)) {
      if (!_onPause) {
        onPause();
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
//    log("------buildbuild---build");
    if (!_onResumed) {
      //说明是 初次加载
      if (NavigatorManger().isTopPage(_className)) {
        _onResumed = true;
        onResume();
        onLoadData();
      }
    }
    return buildWidget(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    _onResumed = false;
    _onPause = false;
    //把改页面 从 页面列表中 去除
    NavigatorManger().removeWidget(_className);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    //此处可以拓展 是不是从前台回到后台
    if (state == AppLifecycleState.resumed) {
      //on resume
      if (NavigatorManger().isTopPage(_className)) {
        onForeground();
        onResume();
      }
    } else if (state == AppLifecycleState.paused) {
      //onpause
      if (NavigatorManger().isTopPage(_className)) {
        onBackground();
        onPause();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  ///初始化一些变量 相当于 onCreate ， 放一下 初始化数据操作
  void onCreate() {}

  ///相当于onResume, 只要页面来到栈顶， 都会调用此方法，网络请求可以放在这个方法
  void onResume() {}

  ///页面被覆盖,暂停
  void onPause() {}

  /// 加载数据
  void onLoadData() {}

  ///返回UI控件 相当于setContentView()
  Widget buildWidget(BuildContext context);

  ///app切回到后台
  void onBackground() {}

  ///app切回到前台
  void onForeground() {}

  ///页面注销方法
  void onDestroy() {}

  void log(String log) {
    debugPrint(_className + "---->" + log);
  }
}
