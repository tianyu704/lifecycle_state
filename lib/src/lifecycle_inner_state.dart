import 'package:flutter/material.dart';
import 'route_name_util.dart';
import 'navigator_manger.dart';
import 'package:event_bus/event_bus.dart';

///
/// Create by Hugo.Guo
/// Date: 2019-08-08
///
abstract class LifecycleInnerState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  bool _isResume = false;
  bool _isPause = false;
  int _position;
  String _tag;
  String _className;

  get className => _className;

  int setPosition();

  String setTag();

  @override
  void initState() {
    // TODO: implement initState
    _className = RouteNameUtil.getRouteNameWithId(context);
    _position = setPosition();
    _tag = setTag();
    onCreate();
    onResume();
    onLoadData();
    eventBus.on<LifecycleInnerEvent>().listen((event) {
      if (event.tag == _tag) {
        if (_position == event.currentPage) {
          if (!_isResume) {
            onResume();
          }
        } else {
          if (!_isPause) {
            onPause();
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    onDestroy();
    super.dispose();
  }

  ///初始化一些变量 相当于 onCreate ， 放一下 初始化数据操作
  void onCreate() {}

  ///相当于onResume, 只要页面来到栈顶， 都会调用此方法
  void onResume() {
    _isResume = true;
    _isPause = false;
  }

  /// 加载数据,网络请求等
  void onLoadData() {}

  ///页面被覆盖,暂停
  void onPause() {
    _isResume = false;
    _isPause = true;
  }

  ///页面销毁的方法
  void onDestroy() {}

  /// log输出
  void log(String log) {
    debugPrint(_className + "---->" + log);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => keepAlive();

  /// 子页面可以决定是否销毁,默认不销毁
  bool keepAlive() {
    return true;
  }
}

class LifecycleInnerEvent extends Notification {
  final int currentPage;
  final String tag;

  LifecycleInnerEvent(this.currentPage, this.tag);
}

EventBus eventBus = EventBus();

onPageChanged(index, tag) {
  eventBus.fire(LifecycleInnerEvent(index, tag));
}
