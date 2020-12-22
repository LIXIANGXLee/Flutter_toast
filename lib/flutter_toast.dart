library flutter_toast;

import 'package:flutter/material.dart';

/// A FlutterToast.
class FlutterToast {
  ///利用overlay实现Toast
  ///context 上下文
  ///message 消息信息
  ///positioned  提示信息位置
  ///backgroundColor 背景色 默认是黑色
  ///textColor 文本颜色 默认是白色
  ///textFont 文本字体大小 默认是14
  ///duration 几秒后消失 默认是两秒
  ///radius 圆角大小 默认大小为6
  static void show(
    BuildContext context,
    String message, {
    double positioned,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    int duration = 3,
    double textFont = 14,
    double radius = 6,
  }) {
    FlutterToastView().dismiss();
    FlutterToastView().createView(message, context, backgroundColor, textColor,
        textFont, duration, positioned, radius);
  }
}

class FlutterToastView {
  /// 类似单列模式
  static FlutterToastView _instance;
  bool _isVisible = false;
  OverlayEntry _overlayEntry;

  /// 创建一个私有的构造函数
  FlutterToastView._();

  ///工厂方法 在此地方使用 类似iOS里的单例模式
  factory FlutterToastView() {
    return _instance ??= FlutterToastView._();
  }

  void createView(
    String message,
    BuildContext context,
    Color backgroundColor,
    Color textColor,
    double textFont,
    int duration,
    double positioned,
    double radius,
  ) async {
    ///创建一个OverlayEntry对象
    _overlayEntry = OverlayEntry(builder: (context) {
      ///外层使用Positioned进行定位，控制在Overlay中的位置
      return Positioned(
          top: positioned == null
              ? MediaQuery.of(context).size.height * 0.5
              : positioned,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(radius)),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      message,
                      style: TextStyle(color: textColor, fontSize: textFont),
                    ),
                  ),
                  color: backgroundColor,
                ),
              ),
            ),
          ));
    });

    _isVisible = true;

    ///往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(_overlayEntry);

    Future.delayed(Duration(seconds: duration)).then((_) {
      dismiss();
    });
  }

  /// 移除展示
  dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}
