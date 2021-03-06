import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pollution_source/module/common/common_model.dart';

/// UI工具类
///
/// 用于获取通用样式，通用widget不放在这里，放在common包中
/// 自定义widget不放在这里，放在widget包中
class UIUtils {
  /// 获取默认的阴影
  static BoxShadow getBoxShadow() {
    return const BoxShadow(
      offset: const Offset(0, 12),
      color: const Color(0xFFDFDFDF),
      blurRadius: 25,
      spreadRadius: -9,
    );
  }

  /// 获取[PopupMenuButton]的下拉菜单
  ///
  /// [icon]是下拉菜单的图标，[text] 下拉菜单的文字
  /// [id]是下拉菜单的id，用于区分点击的菜单
  static Widget getSelectView(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
      value: id,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          Text(text),
        ],
      ),
    );
  }

  /// 获取随机颜色
  static Color getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }

  /// 获取下拉刷新header
  static ClassicalHeader getRefreshClassicalHeader() {
    return ClassicalHeader(
      refreshText: "拉动刷新",
      refreshReadyText: "释放刷新",
      refreshingText: "正在刷新...",
      refreshedText: "刷新完成",
      refreshFailedText: "刷新失败",
      noMoreText: "没有更多数据",
      infoText: "更新于 %T",
    );
  }

  /// 获取上拉加载footer
  static ClassicalFooter getLoadClassicalFooter() {
    return ClassicalFooter(
      loadText: "拉动加载",
      loadReadyText: "释放加载",
      loadingText: "正在加载...",
      loadedText: "加载完成",
      loadFailedText: "加载失败",
      noMoreText: "没有更多数据",
      infoText: "更新于 %T",
    );
  }

  /// 获取一个数组中的最大数
  static double getMax(List<double> items) {
    if (items.length == 0) return 0;
    double temp = items[0];
    items.forEach((item) {
      if (item > temp) {
        temp = item;
      }
    });
    return temp;
  }

  /// 获取一个数组中的最小数
  static double getMin(List<double> items) {
    if (items.length == 0) return 0;
    double temp = items[0];
    items.forEach((item) {
      if (item < temp) {
        temp = item;
      }
    });
    return temp;
  }

  /// 获取Y轴的间隔（坐标轴默认显示5个坐标）
  static double getYAxisInterval(List<ChartData> chartDataList) {
    double maxY = UIUtils.getMax(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
      return chartData.maxY;
    }).toList());
    double minY = UIUtils.getMin(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
      return chartData.minY;
    }).toList());
    return (maxY - minY) / (4);
  }

  /// 获取X轴的间隔（坐标轴默认显示7个坐标）
  static double getXAxisInterval(List<ChartData> chartDataList) {
    double maxX = UIUtils.getMax(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
      return chartData.maxX;
    }).toList());
    double minX = UIUtils.getMin(
        chartDataList.where((chartData) => chartData.checked).map((chartData) {
      return chartData.minX;
    })?.toList());
    return (maxX - minX) / (6);
  }
}
