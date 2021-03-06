import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

//异常申报单详情
class DischargeReportUpload extends Equatable {
  final Enter enter; //企业
  final Discharge discharge; //排口
  final Monitor monitor; //监控点
  final DateTime reportTime; //申报时间
  final DateTime startTime; //开始时间
  final DateTime endTime; //结束时间
  final DataDict stopType; //异常类型
  final String stopReason; //停产原因
  final List<Asset> attachments; //证明材料

  const DischargeReportUpload({
    this.enter,
    this.discharge,
    this.monitor,
    this.reportTime,
    this.startTime,
    this.endTime,
    this.stopType,
    this.stopReason,
    this.attachments,
  });

  @override
  List<Object> get props => [
        enter,
        discharge,
        monitor,
        reportTime,
        startTime,
        endTime,
        stopType,
        stopReason,
        attachments,
      ];

  DischargeReportUpload copyWith({
    Enter enter,
    Discharge discharge,
    Monitor monitor,
    DateTime reportTime,
    DateTime startTime,
    DateTime endTime,
    DataDict stopType,
    String stopReason,
    List<Asset> attachments,
  }) {
    return DischargeReportUpload(
      enter: enter ?? this.enter,
      discharge: discharge ?? this.discharge,
      monitor: monitor ?? this.monitor,
      reportTime: reportTime ?? this.reportTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      stopType: stopType ?? this.stopType,
      stopReason: stopReason ?? this.stopReason,
      attachments: attachments ?? this.attachments,
    );
  }
}
