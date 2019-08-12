import 'package:flutter/material.dart';

///
/// Create by Hugo.Guo
/// Date: 2019-08-09
///
/// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RouteAware {
  String tag = T.toString();

  // 参照State中写法，防止子类获取不到正确的widget。
  T get widget => super.widget;

  //是否在栈顶
  bool _isTop = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onCreate();
    onResume();
    onLoadData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
//    log("deactivate");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//    log("AppLifecycleState:$state");
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (_isTop) {
          onForeground();
          onResume();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (_isTop) {
          onBackground();
          onPause();
        }
        break;
      case AppLifecycleState.suspending:
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    log("didChangeDependencies");
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // TODO: implement didPush
    super.didPush();
//    log("didPush");
    _isTop = true;
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    super.didPushNext();
//    log("didPushNext");
    onPause();
    _isTop = false;
  }

  @override
  void didPop() {
    // TODO: implement didPop
    super.didPop();
//    log("didPop");
    onPause();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
//    log("didPopNext");
    onResume();
    _isTop = true;
  }

  /// 用于让子类去实现的初始化方法
  void onCreate() {
    log("onCreate");
  }

  /// 用于让子类去实现的不可见变为可见时的方法
  void onResume() {
    log("onResume");
  }

  ///加载数据
  void onLoadData() {
    log("onLoadData");
  }

  /// 用于让子类去实现的可见变为不可见时调用的方法。
  void onPause() {
    log("onPause");
  }

  /// 用于让子类去实现的销毁方法。
  void onDestroy() {
    log("onDestroy");
  }

  /// app切回到后台
  void onBackground() {
    log("onBackground");
  }

  /// app切回到前台
  void onForeground() {
    log("onForeground");
  }

  log(String log) {
    debugPrint('$tag --> $log');
  }
}
