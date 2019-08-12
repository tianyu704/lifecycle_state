# lifecycle_state

A flutter package similar to Android&#x27;s lifecycle.  
给flutter添加了类似于Android生命周期的方法，其中`LifecycleState`适用于普通页面，只要把我们用的State替换成LifecycleState即可实现以下方法.  
如果要在PageView中使用，flutter默认每次切换page，旧的page是销毁的，如果你的页面可以这样就可以直接用LifecycleState，但如果你不想每次都销毁重建，就用`LifecycleInnerState`，但这个稍微麻烦的是得手动通知页面状态变化，这个库暂时使用`event_bus`通信，就是在PageView的onPageChanged中调用`eventBus.fire(LifecycleInnerEvent(index, "tag"));`,"tag"是用来标记每个pageview的，避免一个pageview改变，通知到别的pageview。`LifecycleInnerState`中加入了`AutomaticKeepAliveClientMixin`,你自己的类中就不要加了
```
/// 用于让子类去实现的初始化方法
  void onCreate() {
//    log("onCreate");
  }

  /// 用于让子类去实现的不可见变为可见时的方法
  void onResume() {
//    log("onResume");
  }

  ///加载数据
  void onLoadData() {
//    log("onLoadData");
  }

  /// 用于让子类去实现的可见变为不可见时调用的方法。
  void onPause() {
//    log("onPause");
  }

  /// 用于让子类去实现的销毁方法。
  void onDestroy() {
//    log("onDestroy");
  }

  /// app切回到后台
  void onBackground() {
//    log("onBackground");
  }

  /// app切回到前台
  void onForeground() {
//    log("onForeground");
  }
```

# Getting Started
## 导入`lifecycle_state`
```
lifecycle_state:
    git:
      url: "https://github.com/tianyu704/lifecycle_state.git"
```
## MaterialApp中添加`navigatorObservers: [routeObserver]`
```
import 'package:lifecycle_state/lifecycle_state.dart';

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      navigatorObservers: [routeObserver],
      ...
    );
  }
```  
routeObserver 是在lifecycle_state中定义的

