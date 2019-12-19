import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';

//import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';
import 'package:pollution_source/util/ui_utils.dart';

//part 'monitor_detail_model.g.dart';

//监控点详情
//@JsonSerializable()
class MonitorDetail extends Equatable {
  final String enterId; //企业ID
  final String dischargeId; //排口ID
  final String monitorId; //监控点ID
  final String enterName; //企业名称
  final String enterAddress; //企业地址
  final String monitorName; //监控点名称
  final String monitorTypeStr; //监控点类型
  final String monitorCategoryStr; //监控点类别
  final String networkTypeStr; //网络类型
  final String monitorAddress; //监控点地址
  final String mnCode; //数采仪编码
  final String orderCompleteCount; //报警管理单已办结数量
  final String orderTotalCount; //报警管理单全部数量
  final String dischargeReportTotalCount; //排口异常申报单全部数量
  final String factorReportTotalCount; //因子异常申报单全部数量
  final List<ChartData> chartDataList; //图表数据

  const MonitorDetail({
    this.enterId,
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.enterAddress,
    this.monitorName,
    this.monitorTypeStr,
    this.monitorCategoryStr,
    this.networkTypeStr,
    this.monitorAddress,
    this.mnCode,
    this.orderCompleteCount,
    this.orderTotalCount,
    this.dischargeReportTotalCount,
    this.factorReportTotalCount,
    this.chartDataList,
  });

  @override
  List<Object> get props => [
        enterId,
        dischargeId,
        monitorId,
        enterName,
        enterAddress,
        monitorName,
        monitorTypeStr,
        monitorCategoryStr,
        networkTypeStr,
        monitorAddress,
        mnCode,
        orderCompleteCount,
        orderTotalCount,
        dischargeReportTotalCount,
        factorReportTotalCount,
        chartDataList,
      ];

  MonitorDetail copyWith({
    List<ChartData> chartDataList,
  }) {
    return MonitorDetail(
      enterId: this.enterId,
      dischargeId: this.dischargeId,
      monitorId: this.monitorId,
      enterName: this.enterName,
      enterAddress: this.enterAddress,
      monitorName: this.monitorName,
      monitorTypeStr: this.monitorTypeStr,
      monitorCategoryStr: this.monitorCategoryStr,
      networkTypeStr: this.networkTypeStr,
      monitorAddress: this.monitorAddress,
      mnCode: this.mnCode,
      orderCompleteCount: this.orderCompleteCount,
      orderTotalCount: this.orderTotalCount,
      dischargeReportTotalCount: this.dischargeReportTotalCount,
      factorReportTotalCount: this.factorReportTotalCount,
      chartDataList: chartDataList ?? this.chartDataList,
    );
  }

  /*factory MonitorDetail.fromJson(Map<String, dynamic> json) =>
      _$MonitorDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorDetailToJson(this);*/

  static MonitorDetail fromJson(dynamic json) {
    List<PointData> points1 = _getRandomPoints();
    List<PointData> points2 = _getRandomPoints();
    List<PointData> points3 = _getRandomPoints();
    List<PointData> points4 = _getRandomPoints();
    List<PointData> points5 = _getRandomPoints();
    List<PointData> points6 = _getRandomPoints();

    if (SpUtil.getBool(Constant.spUseJavaApi, defValue: Constant.defaultUseJavaApi)) {
      return MonitorDetail(
        enterId: json['enterId'].toString(),
        dischargeId: json['dischargeId'].toString(),
        monitorId: json['monitorId'].toString(),
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        monitorName: json['monitorName'],
        monitorTypeStr: json['monitorTypeStr'],
        monitorCategoryStr: json['monitorCategoryStr'],
        networkTypeStr: json['networkTypeStr'],
        monitorAddress: json['monitorAddress'],
        mnCode: json['mnCode'],
        orderCompleteCount: json['orderCompleteCount'].toString(),
        orderTotalCount: json['orderTotalCount'].toString(),
        dischargeReportTotalCount: json['dischargeReportTotalCount'].toString(),
        factorReportTotalCount: json['factorReportTotalCount'].toString(),
        chartDataList: [
          ChartData(
            factorName: 'PH',
            checked: true,
            lastValue: '13.11',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points1.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points1.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points1.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points1.map((point) {
              return point.y;
            }).toList()),
            points: points1,
          ),
          ChartData(
            factorName: '二氧化硫',
            checked: false,
            lastValue: '42.5',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points2.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points2.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points2.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points2.map((point) {
              return point.y;
            }).toList()),
            points: points2,
          ),
          ChartData(
            factorName: '氨氮',
            checked: false,
            lastValue: '11.4',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points3.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points3.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points3.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points3.map((point) {
              return point.y;
            }).toList()),
            points: points3,
          ),
          ChartData(
            factorName: '化学需氧量',
            checked: false,
            lastValue: '45.24',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points4.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points4.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points4.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points4.map((point) {
              return point.y;
            }).toList()),
            points: points4,
          ),
          ChartData(
            factorName: '臭氧',
            checked: false,
            lastValue: '0.125',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points5.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points5.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points5.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points5.map((point) {
              return point.y;
            }).toList()),
            points: points5,
          ),
          ChartData(
            factorName: '实测NXO',
            checked: false,
            lastValue: '45.12',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points6.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points6.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points6.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points6.map((point) {
              return point.y;
            }).toList()),
            points: points6,
          ),
        ],
      );
    } else {
      return MonitorDetail(
        enterId: json['enterId'],
        dischargeId: json['dischargeId'],
        monitorId: json['monitorId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        monitorName: json['monitorName'],
        monitorTypeStr: json['monitorTypeStr'],
        monitorCategoryStr: json['monitorCategoryStr'],
        networkTypeStr: json['networkTypeStr'],
        monitorAddress: json['monitorAddress'],
        mnCode: json['mnCode'],
        orderCompleteCount: json['orderCompleteCount'],
        orderTotalCount: json['orderTotalCount'],
        dischargeReportTotalCount: json['dischargeReportTotalCount'],
        factorReportTotalCount: json['factorReportTotalCount'],
        chartDataList: [
          ChartData(
            factorName: 'PH',
            checked: true,
            lastValue: '13.11',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points1.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points1.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points1.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points1.map((point) {
              return point.y;
            }).toList()),
            points: points1,
          ),
          ChartData(
            factorName: '二氧化硫',
            checked: false,
            lastValue: '42.5',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points2.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points2.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points2.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points2.map((point) {
              return point.y;
            }).toList()),
            points: points2,
          ),
          ChartData(
            factorName: '氨氮',
            checked: false,
            lastValue: '11.4',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points3.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points3.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points3.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points3.map((point) {
              return point.y;
            }).toList()),
            points: points3,
          ),
          ChartData(
            factorName: '化学需氧量',
            checked: false,
            lastValue: '45.24',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points4.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points4.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points4.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points4.map((point) {
              return point.y;
            }).toList()),
            points: points4,
          ),
          ChartData(
            factorName: '臭氧',
            checked: false,
            lastValue: '0.125',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points5.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points5.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points5.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points5.map((point) {
              return point.y;
            }).toList()),
            points: points5,
          ),
          ChartData(
            factorName: '实测NXO',
            checked: false,
            lastValue: '45.12',
            unit: 'μg/cm3',
            color: UIUtils.getRandomColor(),
            maxX: UIUtils.getMax(points6.map((point) {
              return point.x;
            }).toList()),
            maxY: UIUtils.getMax(points6.map((point) {
              return point.y;
            }).toList()),
            minX: UIUtils.getMin(points6.map((point) {
              return point.x;
            }).toList()),
            minY: UIUtils.getMin(points6.map((point) {
              return point.y;
            }).toList()),
            points: points6,
          ),
        ],
      );
    }
  }

  static List<PointData> _getRandomPoints() {
    return [
      PointData(x: 1571209281000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209311000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209401000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209461000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209521000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209581000, y: Random.secure().nextInt(50).toDouble()),
      PointData(x: 1571209641000, y: Random.secure().nextInt(50).toDouble()),
    ];
  }
}
