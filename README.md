# lifecycle_state

A flutter package similar to Android&#x27;s lifecycle.  
给flutter添加了类似于Android生命周期的方法，其中`LifecycleState`适用于普通页面，只要把我们用的State替换成LifecycleState即可,`LifecycleInnerState`适用于PageView中的页面

# Getting Started
### 导入`lifecycle_state`
```
lifecycle_state:
    git:
      url: "https://github.com/tianyu704/lifecycle_state.git"
```
or
```
lifecycle_state: ^0.0.1
```
### MaterialApp中添加`navigatorObservers: [routeObserver]`
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

### 页面中的使用
1. 直接继承`LifecycleState`

```
class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestPageState();
  }
}

class _TestPageState extends LifecycleState<TestPage> {
  PageController _controller;

  @override
  void onCreate() {
    // TODO: implement onCreate
    super.onCreate();
    _controller = PageController();
//    log("onCreate");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildWidget
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          eventBus.fire(LifecycleInnerEvent(index, "tag"));
        },
        children: <Widget>[
          ItemPage(0, "tag"),
          ItemPage(1, "tag"),
          ItemPage(2, "tag"),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SecondPage();
        }));
      }),
    );
  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    log("onResume");
  }

  @override
  void onPause() {
    // TODO: implement onPause
    super.onPause();
    log("onPause");
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    super.onDestroy();
    log("onDestroy");
  }

  @override
  void onLoadData() {
    // TODO: implement onLoadData
    super.onLoadData();
    log("onLoadData");
  }

  @override
  void onBackground() {
    // TODO: implement onBackground
    super.onBackground();
    log("onBackground");
  }

  @override
  void onForeground() {
    // TODO: implement onForeground
    super.onForeground();
    log("onForeground");
  }
}
```
2. 如果要在PageView中使用，flutter默认每次切换page，旧的page是销毁的，如果你的页面可以这样就可以直接用LifecycleState，但如果你不想每次都销毁重建，就用`LifecycleInnerState`，但这个稍微麻烦的是得手动通知页面状态变化，这里暂时使用`event_bus`通信，就是在PageView的onPageChanged中导包并调用`eventBus.fire(LifecycleInnerEvent(index, "tag"));`,"tag"是用来标记每个pageview的，避免一个pageview改变，通知到别的pageview。`LifecycleInnerState`中加入了`AutomaticKeepAliveClientMixin`防止页面销毁,你自己的类中就不要加了
```
import 'package:schulte_grid_flutter/src/lifecycle_inner_state.dart';
...
PageView(
        controller: _controller,
        onPageChanged: (index) {
          eventBus.fire(LifecycleInnerEvent(index, "tag"));
        },
        children: <Widget>[
          ItemPage(0),
          ItemPage(1),
          ItemPage(2),
        ],
      ),
...
```
```
class ItemPage extends StatefulWidget {
  final int index;
  ItemPage(this.index);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemPageState();
  }
}

class _ItemPageState extends LifecycleInnerState<ItemPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("${widget.index}"),
      ),
    );
  }

  @override
  int setPosition() {
    // TODO: implement setPosition
    return widget.index;
  }

  @override
  void onLoadData() {
    // TODO: implement onLoadData
    super.onLoadData();
    log("onLoadData");
  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    log("onResume");
  }

  @override
  void onPause() {
    // TODO: implement onPause
    super.onPause();
    log("onPause");
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    super.onDestroy();
    log("onDestroy");
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    super.onCreate();
    log("onCreate");
  }

  @override
  // TODO: implement wa
  //  ntKeepAlive
  bool get wantKeepAlive => true;

  @override
  String setTag() {
    // TODO: implement setTag
    return "tag";
  }
}
```
参考：  
1. LifecycleState参考于 https://github.com/tinyvampirepudge/flutter_lifecycle_state ，但是他的这个我用着是有bug的，当跳转到继承原生State的页面中再回来时，方法调用会出错，有的生命周期方法会不调用了  
2. LifecycleInnerState参考于 https://github.com/385841539/flutter_BaseWidget 中的一部分，他这个有一个通用的页面生命周期的基类，采用一个map记录了所有页面，然后通过判断当前页面是栈顶或第二个来调用相应的生命周期方法，因此你必须所有页面都继承他的基类，如果跳转到不继承基类的页面中那么那些方法调用就是错误的

综合这两个的优缺点自己改了一个版本，在想用的时候就用`LifecycleState`或`fecycleInnerState`，不想用也没关系,不影响用的页面


